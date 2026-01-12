using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebDoChoi
{
    public partial class Default : System.Web.UI.Page
    {
        // Lấy chuỗi kết nối từ Web.config
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSanPham();
            }
        }

        private void LoadSanPham()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Truy vấn lấy Tên SP, Giá (từ biến thể đầu tiên) và Ảnh chính
                string sql = @"
                    SELECT TOP 12 s.MaSanPham, s.TenSanPham, b.GiaBan, a.DuongDanAnh 
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    WHERE s.TrangThai = 1
                    ORDER BY s.NgayTao DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Gắn dữ liệu vào Repeater đã tạo ở Default.aspx
                rptSanPham.DataSource = dt;
                rptSanPham.DataBind();
            }
        }
    }
}