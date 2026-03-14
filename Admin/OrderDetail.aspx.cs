using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing; // Dùng để set màu sắc

namespace WebDoChoi.Admin
{
    public partial class OrderDetail : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Kiểm tra tham số ID
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("ManageOrders.aspx"); // Không có ID thì về trang danh sách
                    return;
                }

                LoadThongTinChung(id);
                LoadDanhSachSanPham(id);
            }
        }

        // Lấy thông tin chung của đơn hàng
        private void LoadThongTinChung(string id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // JOIN DonHang và KhachHang để lấy thông tin người mua
                // Lưu ý: DiaChi lấy từ DonHang vì đó là địa chỉ giao hàng cụ thể của đơn này
                string sql = @"SELECT d.MaDonHang, d.NgayDat, d.TrangThaiDonHang, d.TongTien, d.DiaChiGiaoHang, 
                                      k.HoTen, k.SoDienThoai
                               FROM DonHang d
                               JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang
                               WHERE d.MaDonHang = @MaDH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaDH", id);
                conn.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblMaDon.Text = dr["MaDonHang"].ToString();
                    lblNgayDat.Text = Convert.ToDateTime(dr["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                    lblKhachHang.Text = dr["HoTen"].ToString();
                    lblSDT.Text = dr["SoDienThoai"].ToString();
                    lblDiaChi.Text = dr["DiaChiGiaoHang"].ToString();

                    // Hiển thị tổng tiền
                    decimal tongTien = Convert.ToDecimal(dr["TongTien"]);
                    lblTongTien.Text = string.Format("{0:N0} đ", tongTien);

                    // Xử lý màu sắc cho Trạng thái
                    string status = dr["TrangThaiDonHang"].ToString();
                    lblTrangThai.Text = status;
                    switch (status)
                    {
                        case "Mới": lblTrangThai.CssClass += " bg-danger"; break;
                        case "Đang giao": lblTrangThai.CssClass += " bg-warning text-dark"; break;
                        case "Hoàn tất": lblTrangThai.CssClass += " bg-success"; break;
                        default: lblTrangThai.CssClass += " bg-secondary"; break;
                    }
                }
                else
                {
                    // ID có nhưng không tìm thấy trong DB
                    Response.Redirect("ManageOrders.aspx");
                }
            }
        }

        // Lấy danh sách sản phẩm trong đơn hàng
        private void LoadDanhSachSanPham(string id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Câu lệnh JOIN phức tạp theo yêu cầu:
                // ChiTietDonHang -> BienTheSanPham -> SanPham -> AnhSanPham
                string sql = @"
                    SELECT 
                        s.TenSanPham, 
                        ct.SoLuong, 
                        ct.GiaTaiThoiDiemBan,
                        (ct.SoLuong * ct.GiaTaiThoiDiemBan) AS ThanhTien,
                        ISNULL(a.DuongDanAnh, '/Images/no-image.png') AS HinhAnh
                    FROM ChiTietDonHang ct
                    JOIN BienTheSanPham bt ON ct.MaBienThe = bt.MaBienThe
                    JOIN SanPham s ON bt.MaSanPham = s.MaSanPham
                    LEFT JOIN AnhSanPham a ON s.MaSanPham = a.MaSanPham AND a.LaAnhChinh = 1
                    WHERE ct.MaDonHang = @MaDH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaDH", id);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvChiTiet.DataSource = dt;
                gvChiTiet.DataBind();
            }
        }
    }
}