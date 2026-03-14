using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageBrands : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadThuongHieu();
            }
        }

        // 1. Hàm load danh sách ra GridView
        private void LoadThuongHieu()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT * FROM ThuongHieu ORDER BY MaThuongHieu DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvThuongHieu.DataSource = dt;
                gvThuongHieu.DataBind();
            }
        }

        // 2. Sự kiện LƯU (Xử lý Insert hoặc Update)
        protected void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = conn;

                    if (string.IsNullOrEmpty(hdfMaThuongHieu.Value))
                    {
                        // --- TRƯỜNG HỢP THÊM MỚI ---
                        cmd.CommandText = "INSERT INTO ThuongHieu (TenThuongHieu) VALUES (@Ten)";
                        cmd.Parameters.AddWithValue("@Ten", txtTenThuongHieu.Text.Trim());

                        lblThongBao.Text = "Thêm mới thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";
                    }
                    else
                    {
                        // --- TRƯỜNG HỢP CẬP NHẬT ---
                        cmd.CommandText = "UPDATE ThuongHieu SET TenThuongHieu = @Ten WHERE MaThuongHieu = @ID";
                        cmd.Parameters.AddWithValue("@Ten", txtTenThuongHieu.Text.Trim());
                        cmd.Parameters.AddWithValue("@ID", hdfMaThuongHieu.Value);

                        lblThongBao.Text = "Cập nhật thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";
                    }

                    cmd.ExecuteNonQuery();

                    // Reset form và load lại lưới
                    ResetForm();
                    LoadThuongHieu();
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi: " + ex.Message;
                lblThongBao.CssClass = "d-block mb-3 fw-bold text-danger";
            }
        }

        // 3. Sự kiện HỦY
        protected void btnHuy_Click(object sender, EventArgs e)
        {
            ResetForm();
            lblThongBao.Text = ""; // Xóa thông báo
        }

        // 4. Xử lý sự kiện trong GridView (Sửa / Xóa)
        protected void gvThuongHieu_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int maThuongHieu = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sua")
            {
                // Đổ dữ liệu vào Form
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    string sql = "SELECT * FROM ThuongHieu WHERE MaThuongHieu = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", maThuongHieu);

                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtTenThuongHieu.Text = dr["TenThuongHieu"].ToString();
                        hdfMaThuongHieu.Value = dr["MaThuongHieu"].ToString();

                        // Đổi trạng thái nút
                        btnLuu.Text = "Cập nhật";
                        btnLuu.CssClass = "btn btn-warning text-white";

                        lblThongBao.Text = "Đang chỉnh sửa ID: " + maThuongHieu;
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-primary";
                    }
                }
            }
            else if (e.CommandName == "Xoa")
            {
                // Thực hiện Xóa
                try
                {
                    using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        conn.Open();
                        string sql = "DELETE FROM ThuongHieu WHERE MaThuongHieu = @ID";
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@ID", maThuongHieu);
                        cmd.ExecuteNonQuery();

                        LoadThuongHieu();
                        lblThongBao.Text = "Đã xóa thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";

                        // Nếu đang sửa cái vừa xóa thì reset form luôn
                        if (hdfMaThuongHieu.Value == maThuongHieu.ToString())
                        {
                            ResetForm();
                        }
                    }
                }
                catch (SqlException ex)
                {
                    // Bắt lỗi khóa ngoại (Foreign Key) - Mã lỗi 547
                    if (ex.Number == 547)
                    {
                        lblThongBao.Text = "Không thể xóa: Thương hiệu này đang có sản phẩm!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-danger";
                    }
                    else
                    {
                        lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-danger";
                    }
                }
            }
        }

        // Hàm Reset form về trạng thái ban đầu
        private void ResetForm()
        {
            txtTenThuongHieu.Text = "";
            hdfMaThuongHieu.Value = ""; // Xóa ID trong HiddenField
            btnLuu.Text = "Lưu dữ liệu";
            btnLuu.CssClass = "btn btn-success";
        }
    }
}