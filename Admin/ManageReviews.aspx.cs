using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageReviews : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDanhGia(); // Load mặc định lần đầu (không filter)
            }
        }

        // HÀM LOAD DỮ LIỆU TRUNG TÂM (Có hỗ trợ tìm kiếm)
        private void LoadDanhGia(string tuKhoa = "")
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // SQL JOIN 3 bảng để lấy đầy đủ thông tin hiển thị
                string sql = @"
                    SELECT dg.MaDanhGia, dg.SoSao, dg.NoiDung, dg.NgayGui, 
                           s.MaSanPham, s.TenSanPham, 
                           k.HoTen
                    FROM DanhGia dg
                    JOIN SanPham s ON dg.MaSanPham = s.MaSanPham
                    JOIN KhachHang k ON dg.MaKhachHang = k.MaKhachHang
                    WHERE 1=1 "; // Mẹo: Dùng 1=1 để dễ nối chuỗi AND phía sau

                // Logic Lọc SQL động
                if (!string.IsNullOrEmpty(tuKhoa))
                {
                    // Tìm theo Tên Sản Phẩm HOẶC Mã Sản Phẩm
                    sql += " AND (s.TenSanPham LIKE @TuKhoa OR CAST(s.MaSanPham AS NVARCHAR) LIKE @TuKhoa) ";
                }

                // Sắp xếp mới nhất lên đầu
                sql += " ORDER BY dg.NgayGui DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);

                // Gán tham số nếu có tìm kiếm
                if (!string.IsNullOrEmpty(tuKhoa))
                {
                    cmd.Parameters.AddWithValue("@TuKhoa", "%" + tuKhoa + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDanhGia.DataSource = dt;
                gvDanhGia.DataBind();
            }
        }

        // 1. SỰ KIỆN TÌM KIẾM
        protected void btnTim_Click(object sender, EventArgs e)
        {
            // Reset về trang 1 khi tìm kiếm mới để tránh lỗi index
            gvDanhGia.PageIndex = 0;
            LoadDanhGia(txtTuKhoa.Text.Trim());
        }

        // 2. SỰ KIỆN HIỆN TẤT CẢ
        protected void btnTatCa_Click(object sender, EventArgs e)
        {
            txtTuKhoa.Text = ""; // Xóa ô tìm kiếm
            gvDanhGia.PageIndex = 0;
            LoadDanhGia(); // Load lại không tham số
        }

        // 3. SỰ KIỆN PHÂN TRANG (Quan trọng)
        protected void gvDanhGia_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Bước 1: Cập nhật chỉ số trang mới
            gvDanhGia.PageIndex = e.NewPageIndex;

            // Bước 2: Load lại dữ liệu KÈM THEO từ khóa đang tìm
            // Nếu không truyền txtTuKhoa.Text, khi sang trang 2 sẽ bị mất lọc
            LoadDanhGia(txtTuKhoa.Text.Trim());
        }

        // 4. SỰ KIỆN XÓA
        protected void gvDanhGia_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // Lấy ID từ DataKeys (Đã khai báo ở file .aspx)
                int maDG = Convert.ToInt32(gvDanhGia.DataKeys[e.RowIndex].Value);

                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    string sql = "DELETE FROM DanhGia WHERE MaDanhGia = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", maDG);
                    cmd.ExecuteNonQuery();

                    lblThongBao.Text = "Đã xóa đánh giá thành công!";
                    lblThongBao.CssClass = "alert alert-success";

                    // Load lại dữ liệu (giữ nguyên trang và từ khóa hiện tại)
                    LoadDanhGia(txtTuKhoa.Text.Trim());
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi khi xóa: " + ex.Message;
                lblThongBao.CssClass = "alert alert-danger";
            }
        }
    }
}