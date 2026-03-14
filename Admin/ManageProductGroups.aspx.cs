using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageProductGroups : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDanhSachNhom();
            }
        }

        // 1. Hàm Load GridView
        private void LoadDanhSachNhom()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT * FROM NhomSanPham ORDER BY MaNhom DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNhom.DataSource = dt;
                gvNhom.DataBind();
            }
        }

        // 2. Sự kiện LƯU (Thêm hoặc Sửa)
        protected void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = conn;

                    if (string.IsNullOrEmpty(hdfMaNhom.Value))
                    {
                        // INSERT
                        cmd.CommandText = "INSERT INTO NhomSanPham (TenNhom, MoTa) VALUES (@Ten, @MoTa)";
                        cmd.Parameters.AddWithValue("@Ten", txtTenNhom.Text.Trim());
                        cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());

                        lblThongBao.Text = "Thêm nhóm mới thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";
                    }
                    else
                    {
                        // UPDATE
                        cmd.CommandText = "UPDATE NhomSanPham SET TenNhom = @Ten, MoTa = @MoTa WHERE MaNhom = @ID";
                        cmd.Parameters.AddWithValue("@Ten", txtTenNhom.Text.Trim());
                        cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());
                        cmd.Parameters.AddWithValue("@ID", hdfMaNhom.Value);

                        lblThongBao.Text = "Cập nhật nhóm thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";
                    }

                    cmd.ExecuteNonQuery();
                    ResetForm();
                    LoadDanhSachNhom();
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                lblThongBao.CssClass = "d-block mb-3 fw-bold text-danger";
            }
        }

        // 3. Sự kiện GridView (Sửa / Xóa)
        protected void gvNhom_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int maNhom = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sua")
            {
                // Load dữ liệu lên Form để sửa
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    string sql = "SELECT * FROM NhomSanPham WHERE MaNhom = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", maNhom);

                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtTenNhom.Text = dr["TenNhom"].ToString();
                        txtMoTa.Text = dr["MoTa"].ToString();
                        hdfMaNhom.Value = dr["MaNhom"].ToString();

                        // Đổi giao diện nút
                        btnLuu.Text = "Cập nhật";
                        btnLuu.CssClass = "btn btn-warning text-white";
                        lblThongBao.Text = "Đang chỉnh sửa ID: " + maNhom;
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-primary";
                    }
                }
            }
            else if (e.CommandName == "Xoa")
            {
                // LOGIC QUAN TRỌNG: Kiểm tra trước khi xóa
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();

                    // Bước 1: Đếm xem có sản phẩm nào thuộc nhóm này không
                    string sqlCheck = "SELECT COUNT(*) FROM SanPham WHERE MaNhom = @ID";
                    SqlCommand cmdCheck = new SqlCommand(sqlCheck, conn);
                    cmdCheck.Parameters.AddWithValue("@ID", maNhom);

                    int count = (int)cmdCheck.ExecuteScalar();

                    if (count > 0)
                    {
                        // Nếu có sản phẩm -> Báo lỗi ngay lập tức
                        lblThongBao.Text = $"Không thể xóa: Nhóm này đang chứa {count} sản phẩm! Vui lòng xóa hoặc di chuyển sản phẩm trước.";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold alert alert-danger";
                    }
                    else
                    {
                        // Nếu trống -> Thực hiện Xóa
                        string sqlDelete = "DELETE FROM NhomSanPham WHERE MaNhom = @ID";
                        SqlCommand cmdDelete = new SqlCommand(sqlDelete, conn);
                        cmdDelete.Parameters.AddWithValue("@ID", maNhom);
                        cmdDelete.ExecuteNonQuery();

                        lblThongBao.Text = "Đã xóa nhóm sản phẩm thành công!";
                        lblThongBao.CssClass = "d-block mb-3 fw-bold text-success";

                        LoadDanhSachNhom();

                        // Nếu đang sửa cái vừa xóa thì reset form
                        if (hdfMaNhom.Value == maNhom.ToString()) ResetForm();
                    }
                }
            }
        }

        // 4. Nút Hủy
        protected void btnHuy_Click(object sender, EventArgs e)
        {
            ResetForm();
            lblThongBao.Text = "";
        }

        // Hàm Reset Form
        private void ResetForm()
        {
            txtTenNhom.Text = "";
            txtMoTa.Text = "";
            hdfMaNhom.Value = "";
            btnLuu.Text = "Lưu dữ liệu";
            btnLuu.CssClass = "btn btn-success";
        }

        // Hàm Helper: Cắt chuỗi mô tả cho gọn trong bảng
        public string CatChuoiMoTa(object obj)
        {
            if (obj == null) return "";
            string str = obj.ToString();
            if (str.Length > 50)
            {
                return str.Substring(0, 50) + "...";
            }
            return str;
        }
    }
}