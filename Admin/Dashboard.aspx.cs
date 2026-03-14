using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebDoChoi.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // SQL Batch: Viết nhiều lệnh SELECT cùng lúc
                // Query 1: Tổng doanh thu (Chỉ tính đơn 'Hoàn tất')
                // Query 2: Số đơn mới (Trạng thái 'Mới')
                // Query 3: Tổng sản phẩm
                // Query 4: Tổng khách hàng (Trừ Admin ra nếu muốn chính xác)
                // Query 5: Top 5 đơn hàng mới nhất
                string sql = @"
                    SELECT ISNULL(SUM(TongTien), 0) FROM DonHang WHERE TrangThaiDonHang = N'Hoàn tất';
                    
                    SELECT COUNT(*) FROM DonHang WHERE TrangThaiDonHang = N'Mới';
                    
                    SELECT COUNT(*) FROM SanPham;
                    
                    SELECT COUNT(*) FROM KhachHang WHERE VaiTro = 'KhachHang';

                    SELECT TOP 5 d.MaDonHang, k.HoTen, d.NgayDat, d.TongTien, d.TrangThaiDonHang 
                    FROM DonHang d 
                    JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang 
                    ORDER BY d.NgayDat DESC;
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    // 1. Đọc Tổng Doanh Thu
                    if (dr.Read())
                    {
                        decimal doanhThu = Convert.ToDecimal(dr[0]);
                        lblDoanhThu.Text = string.Format("{0:N0} đ", doanhThu);
                    }

                    // 2. Chuyển sang kết quả tiếp theo -> Đọc Số Đơn Mới
                    dr.NextResult();
                    if (dr.Read())
                    {
                        lblDonMoi.Text = dr[0].ToString();
                    }

                    // 3. Chuyển tiếp -> Đọc Tổng Sản Phẩm
                    dr.NextResult();
                    if (dr.Read())
                    {
                        lblSanPham.Text = dr[0].ToString();
                    }

                    // 4. Chuyển tiếp -> Đọc Tổng Khách Hàng
                    dr.NextResult();
                    if (dr.Read())
                    {
                        lblKhachHang.Text = dr[0].ToString();
                    }

                    // 5. Chuyển tiếp -> Đọc danh sách 5 đơn hàng
                    dr.NextResult();
                    // Load vào DataTable để Bind ra GridView
                    DataTable dt = new DataTable();
                    dt.Load(dr);
                    gvDonMoi.DataSource = dt;
                    gvDonMoi.DataBind();
                }
            }
        }

        // Hàm phụ trợ để tô màu Badge trạng thái trong GridView
        public string GetBadgeClass(object status)
        {
            if (status == null) return "bg-secondary";

            string s = status.ToString();
            switch (s)
            {
                case "Mới": return "bg-danger";
                case "Đang giao": return "bg-warning text-dark";
                case "Hoàn tất": return "bg-success";
                case "Đã hủy": return "bg-secondary";
                default: return "bg-info";
            }
        }
    }
}