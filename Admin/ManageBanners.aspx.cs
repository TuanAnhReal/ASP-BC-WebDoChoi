using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageBanners : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadBanners();
        }

        private void LoadBanners()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM QuangCao ORDER BY ThuTu ASC", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvBanner.DataSource = dt;
                gvBanner.DataBind();
            }
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            // 1. Xử lý Upload ảnh
            string fileName = hdfAnhCu.Value; // Mặc định lấy tên ảnh cũ (VD: banner.jpg)

            if (fileUploadAnh.HasFile)
            {
                string ext = Path.GetExtension(fileUploadAnh.FileName).ToLower();
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".gif")
                {
                    // Tạo tên file mới
                    string newFileName = "banner_" + DateTime.Now.Ticks + ext;

                    // Đường dẫn vật lý để lưu file (Vẫn cần đường dẫn đầy đủ để SaveAs)
                    string serverPath = Server.MapPath("~/Images/Banners/" + newFileName);

                    // Tạo thư mục nếu chưa có
                    if (!Directory.Exists(Server.MapPath("~/Images/Banners/")))
                        Directory.CreateDirectory(Server.MapPath("~/Images/Banners/"));

                    fileUploadAnh.SaveAs(serverPath);

                    // QUAN TRỌNG: Chỉ lưu TÊN FILE vào biến để đẩy xuống DB
                    fileName = newFileName;
                }
            }
            else if (string.IsNullOrEmpty(hdfMaQC.Value) && string.IsNullOrEmpty(fileName))
            {
                // Nếu thêm mới mà không chọn ảnh -> Báo lỗi
                lblThongBao.Text = "Vui lòng chọn ảnh banner!";
                lblThongBao.CssClass = "alert alert-danger";
                return;
            }

            // 2. Insert / Update Database
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                if (string.IsNullOrEmpty(hdfMaQC.Value))
                {
                    cmd.CommandText = "INSERT INTO QuangCao(TieuDe, HinhAnh, LienKet, ThuTu, HienThi) VALUES(@Tieude, @Anh, @Link, @TT, @Hien)";
                }
                else
                {
                    cmd.CommandText = "UPDATE QuangCao SET TieuDe=@Tieude, HinhAnh=@Anh, LienKet=@Link, ThuTu=@TT, HienThi=@Hien WHERE MaQC=@ID";
                    cmd.Parameters.AddWithValue("@ID", hdfMaQC.Value);
                }

                cmd.Parameters.AddWithValue("@Tieude", txtTieuDe.Text);
                // QUAN TRỌNG: @Anh bây giờ chỉ chứa tên file (VD: banner_123.jpg)
                cmd.Parameters.AddWithValue("@Anh", fileName);
                cmd.Parameters.AddWithValue("@Link", txtLienKet.Text);
                cmd.Parameters.AddWithValue("@TT", txtThuTu.Text);
                cmd.Parameters.AddWithValue("@Hien", chkHienThi.Checked);

                cmd.ExecuteNonQuery();
                ResetForm();
                LoadBanners();
                lblThongBao.Text = "Lưu thành công!";
                lblThongBao.CssClass = "alert alert-success";
            }
        }

        protected void gvBanner_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Sua")
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SELECT * FROM QuangCao WHERE MaQC=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", id);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hdfMaQC.Value = id.ToString();
                        txtTieuDe.Text = dr["TieuDe"].ToString();
                        txtLienKet.Text = dr["LienKet"].ToString();
                        txtThuTu.Text = dr["ThuTu"].ToString();
                        chkHienThi.Checked = Convert.ToBoolean(dr["HienThi"]);

                        // QUAN TRỌNG: 
                        // 1. HiddenField chỉ lưu tên file (lấy từ DB)
                        string dbFileName = dr["HinhAnh"].ToString();
                        hdfAnhCu.Value = dbFileName;

                        // 2. Image Control phải nối thêm đường dẫn để hiển thị được
                        if (!string.IsNullOrEmpty(dbFileName))
                        {
                            imgPreview.ImageUrl = "~/Images/Banners/" + dbFileName;
                            imgPreview.Visible = true;
                        }

                        btnLuu.Text = "Cập nhật";
                        btnLuu.CssClass = "btn btn-warning";
                    }
                }
            }
            else if (e.CommandName == "Xoa")
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    // Lấy tên ảnh để xóa file vật lý (Optional)
                    SqlCommand cmdGet = new SqlCommand("SELECT HinhAnh FROM QuangCao WHERE MaQC=@ID", conn);
                    cmdGet.Parameters.AddWithValue("@ID", id);
                    string fileName = cmdGet.ExecuteScalar()?.ToString();

                    if (!string.IsNullOrEmpty(fileName))
                    {
                        string physicalPath = Server.MapPath("~/Images/Banners/" + fileName);
                        if (File.Exists(physicalPath)) File.Delete(physicalPath);
                    }

                    // Xóa trong DB
                    SqlCommand cmd = new SqlCommand("DELETE FROM QuangCao WHERE MaQC=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", id);
                    cmd.ExecuteNonQuery();
                    LoadBanners();
                }
            }
        }

        protected void btnHuy_Click(object sender, EventArgs e) { ResetForm(); }

        private void ResetForm()
        {
            txtTieuDe.Text = txtLienKet.Text = "";
            txtThuTu.Text = "1";
            hdfMaQC.Value = hdfAnhCu.Value = "";
            imgPreview.Visible = false;
            btnLuu.Text = "Lưu Banner";
            btnLuu.CssClass = "btn btn-success";
            lblThongBao.Text = "";
        }
    }
}