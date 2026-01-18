using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageProducts : System.Web.UI.Page
    {
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
                // Câu lệnh SQL sử dụng GROUP BY để gộp dữ liệu biến thể
                // ISNULL(MIN(...), 0) để xử lý trường hợp sản phẩm chưa có biến thể nào
                string sql = @"
                    SELECT 
                        s.MaSanPham, 
                        s.TenSanPham, 
                        ISNULL(th.TenThuongHieu, 'Không xác định') AS TenThuongHieu,
                        ISNULL(a.DuongDanAnh, '/Images/no-image.png') AS HinhAnh,
                        ISNULL(MIN(bt.GiaBan), 0) AS GiaBan, 
                        ISNULL(SUM(bt.SoLuongTon), 0) AS TongTon
                    FROM SanPham s
                    LEFT JOIN ThuongHieu th ON s.MaThuongHieu = th.MaThuongHieu
                    LEFT JOIN AnhSanPham a ON s.MaSanPham = a.MaSanPham AND a.LaAnhChinh = 1
                    LEFT JOIN BienTheSanPham bt ON s.MaSanPham = bt.MaSanPham
                    GROUP BY s.MaSanPham, s.TenSanPham, th.TenThuongHieu, a.DuongDanAnh
                    ORDER BY s.MaSanPham DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSanPham.DataSource = dt;
                gvSanPham.DataBind();
            }
        }

        // Xử lý sự kiện Xóa
        protected void gvSanPham_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Lấy ID từ DataKey
            int maSP = Convert.ToInt32(gvSanPham.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "DELETE FROM SanPham WHERE MaSanPham = @MaSP";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);

                try
                {
                    // Thực thi lệnh xóa
                    // Lưu ý: Do trong Database đã thiết lập ON DELETE CASCADE cho bảng AnhSanPham và BienTheSanPham,
                    // nên khi xóa SanPham, các bảng con đó sẽ tự động sạch dữ liệu.
                    cmd.ExecuteNonQuery();

                    lblThongBao.Text = "Đã xóa sản phẩm thành công!";
                    lblThongBao.CssClass = "alert alert-success";

                    // Tải lại danh sách
                    LoadSanPham();
                }
                catch (SqlException ex)
                {
                    // Mã lỗi 547 là lỗi vi phạm ràng buộc khóa ngoại (Foreign Key Constraint)
                    if (ex.Number == 547)
                    {
                        lblThongBao.Text = "Không thể xóa: Sản phẩm này đã tồn tại trong các đơn hàng cũ. Hãy đổi trạng thái sang 'Ngừng kinh doanh' thay vì xóa.";
                        lblThongBao.CssClass = "alert alert-danger";
                    }
                    else
                    {
                        lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                        lblThongBao.CssClass = "alert alert-danger";
                    }
                }
            }
        }
    }
}