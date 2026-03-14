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

        // HÀM TẢI DỮ LIỆU & TÌM KIẾM
        private void LoadSanPham()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Sử dụng 1=1 để dễ dàng gắn thêm điều kiện WHERE phía sau
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
                    WHERE 1=1 ";

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                // Kiểm tra xem có từ khóa tìm kiếm không
                string searchText = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(searchText))
                {
                    // Nếu người dùng nhập số (có thể là tìm theo Mã sản phẩm)
                    if (int.TryParse(searchText, out int searchId))
                    {
                        sql += " AND (s.MaSanPham = @SearchID OR s.TenSanPham LIKE @SearchName) ";
                        cmd.Parameters.AddWithValue("@SearchID", searchId);
                        cmd.Parameters.AddWithValue("@SearchName", "%" + searchText + "%");
                    }
                    else
                    {
                        // Nếu nhập chữ, chỉ tìm theo tên
                        sql += " AND (s.TenSanPham LIKE @SearchName) ";
                        cmd.Parameters.AddWithValue("@SearchName", "%" + searchText + "%");
                    }
                }

                // Chốt lại câu lệnh bằng GROUP BY và ORDER BY
                sql += @" GROUP BY s.MaSanPham, s.TenSanPham, th.TenThuongHieu, a.DuongDanAnh
                          ORDER BY s.MaSanPham DESC";

                cmd.CommandText = sql;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSanPham.DataSource = dt;
                gvSanPham.DataBind();
            }
        }

        // SỰ KIỆN CLICK NÚT TÌM KIẾM
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvSanPham.PageIndex = 0; // Trở về trang đầu tiên khi tìm kiếm mới
            LoadSanPham();
        }

        // SỰ KIỆN CHUYỂN TRANG
        protected void gvSanPham_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSanPham.PageIndex = e.NewPageIndex;
            LoadSanPham();
        }

        // SỰ KIỆN XÓA SẢN PHẨM (Giữ nguyên của bạn)
        protected void gvSanPham_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int maSP = Convert.ToInt32(gvSanPham.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "DELETE FROM SanPham WHERE MaSanPham = @MaSP";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);

                try
                {
                    cmd.ExecuteNonQuery();
                    lblThongBao.Text = "Đã xóa sản phẩm thành công!";
                    lblThongBao.CssClass = "alert alert-success d-block";
                    LoadSanPham();
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 547)
                    {
                        lblThongBao.Text = "Không thể xóa: Sản phẩm này đã tồn tại trong các đơn hàng cũ. Hãy đổi trạng thái sang 'Ngừng kinh doanh' thay vì xóa.";
                    }
                    else
                    {
                        lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                    }
                    lblThongBao.CssClass = "alert alert-danger d-block";
                }
            }
        }
    }
}