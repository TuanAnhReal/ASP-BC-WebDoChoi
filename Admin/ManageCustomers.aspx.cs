using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageCustomers : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKhachHang("");
            }
        }

        // Hàm load dữ liệu có hỗ trợ tìm kiếm
        private void LoadKhachHang(string keyword)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // SQL Logic: Lấy tất cả KhachHang, TRỪ những người có VaiTro là Admin
                string sql = "SELECT * FROM KhachHang WHERE VaiTro != 'Admin'";

                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += " AND (HoTen LIKE @Keyword OR SoDienThoai LIKE @Keyword)";
                }

                sql += " ORDER BY MaKhachHang DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(keyword))
                {
                    cmd.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvKhachHang.DataSource = dt;
                gvKhachHang.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadKhachHang(txtSearch.Text.Trim());
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadKhachHang("");
        }

        // Xử lý sự kiện RowCommand (Khóa / Mở Khóa)
        protected void gvKhachHang_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int maKH = Convert.ToInt32(e.CommandArgument);
            int trangThaiMoi = 1; // Mặc định là mở

            if (e.CommandName == "KhoaTaiKhoan")
            {
                trangThaiMoi = 0; // Set về 0 để khóa
            }
            else if (e.CommandName == "MoKhoaTaiKhoan")
            {
                trangThaiMoi = 1; // Set về 1 để mở
            }
            else
            {
                return; // Nếu không phải 2 lệnh trên thì thoát
            }

            // Thực thi Update
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "UPDATE KhachHang SET TrangThai = @TrangThai WHERE MaKhachHang = @MaKH";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@TrangThai", trangThaiMoi);
                cmd.Parameters.AddWithValue("@MaKH", maKH);

                cmd.ExecuteNonQuery();

                // Thông báo & Load lại lưới
                string actionText = (trangThaiMoi == 1) ? "Đã mở khóa" : "Đã khóa";
                lblThongBao.Text = $"{actionText} thành công tài khoản ID: {maKH}";
                lblThongBao.CssClass = (trangThaiMoi == 1) ? "alert alert-success" : "alert alert-warning";

                LoadKhachHang(txtSearch.Text.Trim());
            }
        }
    }
}