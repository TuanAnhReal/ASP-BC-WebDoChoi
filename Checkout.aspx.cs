using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class Checkout : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        string vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
        string vnp_TmnCode = "MUN53JH8";
        string vnp_HashSecret = "ENMERXK0MUVDHS6FAGJVFWAAYCS7530O";
        string vnp_Returnurl = "https://localhost:44396/PaymentReturn.aspx";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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

        private void LoadThongTinKhachHang()
        {
            UserSession user = Session["KhachHang"] as UserSession;
            if (user != null)
            {
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
                    }
                }
            }
        }

        // --- XỬ LÝ NÚT ĐẶT HÀNG (ĐÃ HOÀN THIỆN) ---
        protected void btnOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0) return;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                // Biến để lưu mã đơn hàng dùng cho việc Redirect sau khi Commit
                int maDonHangVuaTao = 0;

                try
                {
                    // --- BƯỚC 1: XỬ LÝ KHÁCH HÀNG ---
                    int maKhachHang = 0;
                    if (Session["KhachHang"] != null)
                    {
                        UserSession user = (UserSession)Session["KhachHang"];
                        maKhachHang = user.MaKhachHang;
                    }
                    else
                    {
                        // Nếu khách chưa đăng nhập -> Tạo tài khoản vãng lai (Guest)
                        string sqlKhach = @"INSERT INTO KhachHang (HoTen, Email, SoDienThoai, DiaChi, MatKhau) 
                                            VALUES (@HoTen, @Email, @SDT, @DiaChi, 'GuestOrder');
                                            SELECT SCOPE_IDENTITY();";
                        SqlCommand cmdKhach = new SqlCommand(sqlKhach, conn, transaction);
                        cmdKhach.Parameters.AddWithValue("@HoTen", txtHoTen.Text);
                        cmdKhach.Parameters.AddWithValue("@Email", txtEmail.Text);
                        cmdKhach.Parameters.AddWithValue("@SDT", txtSDT.Text);
                        cmdKhach.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text);

                        // Lấy ID khách hàng vừa tạo
                        maKhachHang = Convert.ToInt32(cmdKhach.ExecuteScalar());
                    }

                    // --- BƯỚC 2: INSERT ĐƠN HÀNG ---
                    string trangThaiDon = "Mới";
                    if (rblHinhThucTT.SelectedValue == "VNPAY")
                    {
                        trangThaiDon = "Chờ thanh toán";
                    }

                    string sqlDonHang = @"INSERT INTO DonHang (MaKhachHang, NgayDat, TongTien, TrangThaiDonHang, DiaChiGiaoHang) 
                                          VALUES (@MaKH, GETDATE(), @TongTien, @TrangThai, @DiaChi);
                                          SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdDonHang = new SqlCommand(sqlDonHang, conn, transaction);
                    cmdDonHang.Parameters.AddWithValue("@MaKH", maKhachHang);
                    cmdDonHang.Parameters.AddWithValue("@TongTien", cart.Sum(x => x.ThanhTien));
                    cmdDonHang.Parameters.AddWithValue("@TrangThai", trangThaiDon);
                    cmdDonHang.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text);

                    maDonHangVuaTao = Convert.ToInt32(cmdDonHang.ExecuteScalar());

                    // --- BƯỚC 3: INSERT CHI TIẾT & TRỪ KHO ---
                    foreach (var item in cart)
                    {
                        // Lưu chi tiết đơn hàng
                        string sqlChiTiet = @"INSERT INTO ChiTietDonHang (MaDonHang, MaBienThe, SoLuong, GiaTaiThoiDiemBan)
                                              VALUES (@MaDonHang, (SELECT TOP 1 MaBienThe FROM BienTheSanPham WHERE MaSanPham = @MaSP), @SoLuong, @GiaBan)";

                        SqlCommand cmdChiTiet = new SqlCommand(sqlChiTiet, conn, transaction);
                        cmdChiTiet.Parameters.AddWithValue("@MaDonHang", maDonHangVuaTao);
                        cmdChiTiet.Parameters.AddWithValue("@MaSP", item.MaSanPham);
                        cmdChiTiet.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                        cmdChiTiet.Parameters.AddWithValue("@GiaBan", item.GiaBan);
                        cmdChiTiet.ExecuteNonQuery();

                        // Trừ tồn kho (Giả sử bảng SanPham có cột SoLuongTon)
                        string sqlTruKho = @"UPDATE BienTheSanPham 
                                             SET SoLuongTon = SoLuongTon - @SL 
                                             WHERE MaSanPham = @MaSP";
                        SqlCommand cmdKho = new SqlCommand(sqlTruKho, conn, transaction);
                        cmdKho.Parameters.AddWithValue("@SL", item.SoLuong);
                        cmdKho.Parameters.AddWithValue("@MaSP", item.MaSanPham);
                        cmdKho.ExecuteNonQuery();
                    }

                    // Lưu tất cả thay đổi vào Database
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblError.Text = "Lỗi xử lý đơn hàng: " + ex.Message;
                    return; // Dừng lại nếu lỗi, không thực hiện chuyển hướng
                }

                // --- BƯỚC 4: XỬ LÝ THANH TOÁN (RA KHỎI TRANSACTION) ---
                if (rblHinhThucTT.SelectedValue == "VNPAY")
                {
                    
                }
                else
                {
                    // Thanh toán COD
                    string mailTo = txtEmail.Text;
                    string sub = "Xác nhận đơn hàng #" + maDonHangVuaTao;
                    string body = "Cảm ơn bạn đã đặt hàng. Tổng tiền: " + string.Format("{0:N0}", cart.Sum(x => x.ThanhTien));

                    Task.Run(() => MailHelper.SendMail(mailTo, sub, body));

                    Session["Cart"] = null;
                    Response.Redirect("OrderSuccess.aspx");
                }
            }
        }
    }
}