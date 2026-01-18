using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq; // Để dùng Sum()
using WebDoChoi.Models; // Import namespace chứa UserSession và CartItem

namespace WebDoChoi
{
    public partial class Checkout : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;
        bool datHangThanhCong = false;// Biến cờ để kiểm tra đặt hàng thành công

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra nếu giỏ hàng trống thì đá về trang chủ
                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                if (cart == null || cart.Count == 0)
                {
                    Response.Redirect("Default.aspx");
                    return;
                }

                LoadGioHang(cart);
                LoadThongTinKhachHang();
            }
        }

        private void LoadGioHang(List<CartItem> cart)
        {
            gvCheckout.DataSource = cart;
            gvCheckout.DataBind();
            lblTongTien.Text = string.Format("{0:N0} đ", cart.Sum(x => x.ThanhTien));
        }

        // Tự động điền thông tin nếu đã đăng nhập
        private void LoadThongTinKhachHang()
        {
            UserSession user = Session["KhachHang"] as UserSession;
            if (user != null)
            {
                // Truy vấn lại Database để lấy thông tin mới nhất (SĐT, Địa chỉ)
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SELECT * FROM KhachHang WHERE MaKhachHang = @MaKH", conn);
                    cmd.Parameters.AddWithValue("@MaKH", user.MaKhachHang);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtHoTen.Text = dr["HoTen"].ToString();
                        txtEmail.Text = dr["Email"].ToString();
                        txtSDT.Text = dr["SoDienThoai"].ToString();
                        txtDiaChi.Text = dr["DiaChi"].ToString();

                        // Khóa Email lại không cho sửa (nếu muốn)
                        txtEmail.Enabled = false;
                    }
                }
            }
        }

        protected void btnOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0) return;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                // BẮT ĐẦU TRANSACTION
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    int maKhachHang = 0;

                    // BƯỚC 1: XÁC ĐỊNH KHÁCH HÀNG
                    if (Session["KhachHang"] != null)
                    {
                        UserSession user = (UserSession)Session["KhachHang"];
                        maKhachHang = user.MaKhachHang;

                        // (Tùy chọn) Cập nhật lại địa chỉ giao hàng mới nhất vào bảng KhachHang nếu muốn
                    }
                    else
                    {
                        // Khách chưa đăng nhập -> Insert KhachHang mới
                        string sqlKhach = @"INSERT INTO KhachHang (HoTen, Email, SoDienThoai, DiaChi, MatKhau) 
                                            VALUES (@HoTen, @Email, @SDT, @DiaChi, 'GuestOrder');
                                            SELECT SCOPE_IDENTITY();"; // Lấy ID vừa tạo

                        SqlCommand cmdKhach = new SqlCommand(sqlKhach, conn, transaction);
                        cmdKhach.Parameters.AddWithValue("@HoTen", txtHoTen.Text);
                        cmdKhach.Parameters.AddWithValue("@Email", txtEmail.Text);
                        cmdKhach.Parameters.AddWithValue("@SDT", txtSDT.Text);
                        cmdKhach.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text);

                        // ExecuteScalar trả về ID vừa insert
                        maKhachHang = Convert.ToInt32(cmdKhach.ExecuteScalar());
                    }

                    // BƯỚC 2: TẠO ĐƠN HÀNG (DONHANG)
                    string sqlDonHang = @"INSERT INTO DonHang (MaKhachHang, NgayDat, TongTien, TrangThaiDonHang, DiaChiGiaoHang) 
                                          VALUES (@MaKH, GETDATE(), @TongTien, N'Mới', @DiaChi);
                                          SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdDonHang = new SqlCommand(sqlDonHang, conn, transaction);
                    cmdDonHang.Parameters.AddWithValue("@MaKH", maKhachHang);
                    cmdDonHang.Parameters.AddWithValue("@TongTien", cart.Sum(x => x.ThanhTien));
                    cmdDonHang.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text); // Lưu địa chỉ giao hàng cụ thể cho đơn này

                    int maDonHang = Convert.ToInt32(cmdDonHang.ExecuteScalar());

                    // BƯỚC 3: DUYỆT GIỎ HÀNG -> INSERT CHI TIẾT & TRỪ TỒN KHO
                    foreach (var item in cart)
                    {
                        // 3a. Insert ChiTietDonHang
                        // Lưu ý: Cần lấy MaBienThe chính xác. 
                        // Giả sử trong CartItem bạn lưu MaSanPham, ta cần logic để lấy MaBienThe (hoặc giả định bán biến thể đầu tiên)
                        // Để đơn giản cho bài này, tôi giả định logic lấy MaBienThe đã được xử lý hoặc CartItem có chứa MaBienThe.
                        // Ở đây tôi dùng subquery để lấy MaBienThe đầu tiên của SP đó.

                        string sqlChiTiet = @"
                            INSERT INTO ChiTietDonHang (MaDonHang, MaBienThe, SoLuong, GiaTaiThoiDiemBan)
                            VALUES (@MaDonHang, (SELECT TOP 1 MaBienThe FROM BienTheSanPham WHERE MaSanPham = @MaSP), @SoLuong, @Gia);

                            UPDATE BienTheSanPham 
                            SET SoLuongTon = SoLuongTon - @SoLuong 
                            WHERE MaSanPham = @MaSP AND MaBienThe = (SELECT TOP 1 MaBienThe FROM BienTheSanPham WHERE MaSanPham = @MaSP)";

                        SqlCommand cmdChiTiet = new SqlCommand(sqlChiTiet, conn, transaction);
                        cmdChiTiet.Parameters.AddWithValue("@MaDonHang", maDonHang);
                        cmdChiTiet.Parameters.AddWithValue("@MaSP", item.MaSanPham);
                        cmdChiTiet.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                        cmdChiTiet.Parameters.AddWithValue("@Gia", item.GiaBan);

                        cmdChiTiet.ExecuteNonQuery();
                    }

                    // BƯỚC 4: COMMIT TRANSACTION
                    transaction.Commit();

                    datHangThanhCong = true;
                }
                catch (Exception ex)
                {
                    // NẾU CÓ LỖI -> ROLLBACK (Hoàn tác toàn bộ)
                    if (!datHangThanhCong)
                    {
                        transaction.Rollback();
                    }
                    lblError.Text = "Có lỗi xảy ra trong quá trình xử lý đơn hàng: " + ex.Message;
                }
            }
            // BƯỚC 5: CHUYỂN HƯỚNG (Ra khỏi khối transaction)
            if (datHangThanhCong)
            {
                Session["Cart"] = null; // Xóa giỏ hàng
                Response.Redirect("OrderSuccess.aspx");
            }
        }
    }
}