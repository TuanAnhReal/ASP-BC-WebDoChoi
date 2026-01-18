using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class MyOrderDetail : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["KhachHang"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("MyOrders.aspx");
                    return;
                }

                LoadChiTietDonHang(id);
            }
        }

        private void LoadChiTietDonHang(string maDonHang)
        {
            UserSession user = (UserSession)Session["KhachHang"];

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // 1. Lấy thông tin chung + KIỂM TRA BẢO MẬT
                // Điều kiện WHERE MaDonHang = @ID AND MaKhachHang = @UserID
                // Nếu không khớp UserID -> Không ra kết quả -> Không xem được
                string sqlInfo = @"
                    SELECT d.*, k.HoTen, k.SoDienThoai
                    FROM DonHang d
                    JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang
                    WHERE d.MaDonHang = @MaDH AND d.MaKhachHang = @MaKH";

                SqlCommand cmd = new SqlCommand(sqlInfo, conn);
                cmd.Parameters.AddWithValue("@MaDH", maDonHang);
                cmd.Parameters.AddWithValue("@MaKH", user.MaKhachHang); // Quan trọng!

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblMaDon.Text = dr["MaDonHang"].ToString();
                    lblNgayDat.Text = Convert.ToDateTime(dr["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                    lblTongTien.Text = string.Format("{0:N0} đ", dr["TongTien"]);
                    lblTrangThai.Text = dr["TrangThaiDonHang"].ToString();

                    // Thông tin người nhận (Lấy từ DonHang nếu có lưu riêng, hoặc từ KhachHang)
                    // Ở đây tôi hiển thị địa chỉ giao hàng cụ thể của đơn này
                    lblDiaChi.Text = dr["DiaChiGiaoHang"].ToString();
                    lblNguoiNhan.Text = dr["HoTen"].ToString();
                    lblSDT.Text = dr["SoDienThoai"].ToString();

                    dr.Close(); // Đóng reader để chạy query tiếp theo

                    // 2. Lấy danh sách sản phẩm
                    string sqlItems = @"
                        SELECT s.TenSanPham, ct.SoLuong, ct.GiaTaiThoiDiemBan,
                               (ct.SoLuong * ct.GiaTaiThoiDiemBan) as ThanhTien,
                               ISNULL(a.DuongDanAnh, '/Images/no-image.png') as HinhAnh
                        FROM ChiTietDonHang ct
                        JOIN BienTheSanPham bt ON ct.MaBienThe = bt.MaBienThe
                        JOIN SanPham s ON bt.MaSanPham = s.MaSanPham
                        LEFT JOIN AnhSanPham a ON s.MaSanPham = a.MaSanPham AND a.LaAnhChinh = 1
                        WHERE ct.MaDonHang = @MaDH";

                    SqlDataAdapter da = new SqlDataAdapter(sqlItems, conn);
                    da.SelectCommand.Parameters.AddWithValue("@MaDH", maDonHang);

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvChiTiet.DataSource = dt;
                    gvChiTiet.DataBind();
                }
                else
                {
                    // Nếu không tìm thấy đơn hàng HOẶC đơn hàng không phải của User này
                    Response.Redirect("MyOrders.aspx");
                }
            }
        }
    }
}