using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO; // Để xử lý File
using System.Web;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ProductEditor : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropDownData();

                // Kiểm tra xem đang Thêm mới hay Sửa
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    lblTitle.Text = "CẬP NHẬT SẢN PHẨM (Mã: " + id + ")";
                    LoadData(id);
                }
            }
        }

        // 1. Đổ dữ liệu vào DropDownList
        private void LoadDropDownData()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                // Load Thương hiệu
                SqlDataAdapter daTH = new SqlDataAdapter("SELECT MaThuongHieu, TenThuongHieu FROM ThuongHieu", conn);
                DataTable dtTH = new DataTable();
                daTH.Fill(dtTH);
                ddlThuongHieu.DataSource = dtTH;
                ddlThuongHieu.DataTextField = "TenThuongHieu";
                ddlThuongHieu.DataValueField = "MaThuongHieu";
                ddlThuongHieu.DataBind();
                ddlThuongHieu.Items.Insert(0, new ListItem("-- Chọn Thương hiệu --", "0"));

                // Load Độ tuổi
                SqlDataAdapter daDT = new SqlDataAdapter("SELECT MaDoTuoi, KhoangDoTuoi FROM DoTuoi", conn);
                DataTable dtDT = new DataTable();
                daDT.Fill(dtDT);
                ddlDoTuoi.DataSource = dtDT;
                ddlDoTuoi.DataTextField = "KhoangDoTuoi";
                ddlDoTuoi.DataValueField = "MaDoTuoi";
                ddlDoTuoi.DataBind();
                ddlDoTuoi.Items.Insert(0, new ListItem("-- Chọn Độ tuổi --", "0"));
            }
        }

        // 2. Load dữ liệu cũ khi Sửa
        private void LoadData(string id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Lấy thông tin chung + Giá + Ảnh chính
                string sql = @"
                    SELECT TOP 1 s.*, b.GiaBan, b.SoLuongTon, a.DuongDanAnh
                    FROM SanPham s
                    LEFT JOIN BienTheSanPham b ON s.MaSanPham = b.MaSanPham
                    LEFT JOIN AnhSanPham a ON s.MaSanPham = a.MaSanPham AND a.LaAnhChinh = 1
                    WHERE s.MaSanPham = @MaSP";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtTenSP.Text = dr["TenSanPham"].ToString();
                    txtMoTa.Text = dr["MoTaChiTiet"].ToString();
                    ddlThuongHieu.SelectedValue = dr["MaThuongHieu"].ToString();
                    ddlDoTuoi.SelectedValue = dr["MaDoTuoi"].ToString();

                    // Xử lý số: Bỏ phần thập phân thừa (.00)
                    txtGia.Text = string.Format("{0:0}", dr["GiaBan"]);
                    txtTonKho.Text = dr["SoLuongTon"].ToString();

                    // Xử lý ảnh
                    string imgUrl = dr["DuongDanAnh"].ToString();
                    if (!string.IsNullOrEmpty(imgUrl))
                    {
                        imgPreview.ImageUrl = ResolveUrl("~/Images/Products/" + imgUrl);
                        imgPreview.Visible = true;
                        hdfOldImage.Value = imgUrl; // Lưu lại đường dẫn cũ
                        lblCurrentImg.Text = "Ảnh hiện tại";
                    }
                }
            }
            // Load Album Ảnh Phụ
            LoadAlbum(id);
        }

        // 3. Sự kiện Lưu (Quan trọng - Đã sửa lỗi Album)
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string id = Request.QueryString["id"];
            bool isUpdate = !string.IsNullOrEmpty(id);
            string finalImagePath = hdfOldImage.Value; // Mặc định lấy ảnh cũ

            // --- 1. XỬ LÝ UPLOAD ẢNH CHÍNH ---
            if (fileUploadAnh.HasFile)
            {
                string fileExt = Path.GetExtension(fileUploadAnh.FileName).ToLower();
                if (fileExt == ".jpg" || fileExt == ".png" || fileExt == ".jpeg" || fileExt == ".gif")
                {
                    string folderPath = Server.MapPath("~/Images/Products/");
                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    string fileName = "prod_" + DateTime.Now.Ticks + fileExt;
                    string serverPath = Path.Combine(folderPath, fileName);

                    fileUploadAnh.SaveAs(serverPath);
                    finalImagePath = fileName; // Chỉ lưu tên file vào DB
                }
                else
                {
                    lblError.Text = "Chỉ chấp nhận file ảnh (jpg, png, gif)!";
                    lblError.CssClass = "alert alert-danger";
                    return;
                }
            }

            if (!isUpdate && string.IsNullOrEmpty(finalImagePath))
            {
                finalImagePath = "no-image.png";
            }

            // --- 2. XỬ LÝ DATABASE (Transaction) ---
            bool isSuccess = false;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    int maSanPham = 0;

                    if (isUpdate)
                    {
                        // --- LOGIC CẬP NHẬT ---
                        maSanPham = int.Parse(id);

                        // Update SanPham
                        string sqlUpdateSP = "UPDATE SanPham SET TenSanPham=@Ten, MaThuongHieu=@MaTH, MaDoTuoi=@MaDT, MoTaChiTiet=@MoTa WHERE MaSanPham=@MaSP";
                        SqlCommand cmdSP = new SqlCommand(sqlUpdateSP, conn, transaction);
                        cmdSP.Parameters.AddWithValue("@Ten", txtTenSP.Text);
                        cmdSP.Parameters.AddWithValue("@MaTH", ddlThuongHieu.SelectedValue);
                        cmdSP.Parameters.AddWithValue("@MaDT", ddlDoTuoi.SelectedValue);
                        cmdSP.Parameters.AddWithValue("@MoTa", txtMoTa.Text);
                        cmdSP.Parameters.AddWithValue("@MaSP", maSanPham);
                        cmdSP.ExecuteNonQuery();

                        // Update BienThe
                        string sqlUpdateBT = "UPDATE BienTheSanPham SET GiaBan=@Gia, SoLuongTon=@Ton WHERE MaSanPham=@MaSP";
                        SqlCommand cmdBT = new SqlCommand(sqlUpdateBT, conn, transaction);
                        cmdBT.Parameters.AddWithValue("@Gia", decimal.Parse(txtGia.Text));
                        cmdBT.Parameters.AddWithValue("@Ton", int.Parse(txtTonKho.Text));
                        cmdBT.Parameters.AddWithValue("@MaSP", maSanPham);
                        cmdBT.ExecuteNonQuery();

                        // Update Ảnh Chính (Nếu có ảnh mới)
                        if (fileUploadAnh.HasFile)
                        {
                            string sqlUpdateAnh = "UPDATE AnhSanPham SET DuongDanAnh=@Anh WHERE MaSanPham=@MaSP AND LaAnhChinh=1";
                            SqlCommand cmdAnh = new SqlCommand(sqlUpdateAnh, conn, transaction);
                            cmdAnh.Parameters.AddWithValue("@Anh", finalImagePath);
                            cmdAnh.Parameters.AddWithValue("@MaSP", maSanPham);
                            int rowEffect = cmdAnh.ExecuteNonQuery();

                            if (rowEffect == 0) // Nếu chưa có ảnh thì Insert
                            {
                                string sqlInsertAnh = "INSERT INTO AnhSanPham(MaSanPham, DuongDanAnh, LaAnhChinh) VALUES(@MaSP, @Anh, 1)";
                                SqlCommand cmdNewAnh = new SqlCommand(sqlInsertAnh, conn, transaction);
                                cmdNewAnh.Parameters.AddWithValue("@MaSP", maSanPham);
                                cmdNewAnh.Parameters.AddWithValue("@Anh", finalImagePath);
                                cmdNewAnh.ExecuteNonQuery();
                            }
                        }
                    }
                    else
                    {
                        // --- LOGIC THÊM MỚI ---
                        // 1. Insert SP
                        string sqlInsertSP = @"INSERT INTO SanPham (TenSanPham, MaThuongHieu, MaDoTuoi, MoTaChiTiet, TrangThai) 
                                               VALUES (@Ten, @MaTH, @MaDT, @MoTa, 1); SELECT SCOPE_IDENTITY();";
                        SqlCommand cmdSP = new SqlCommand(sqlInsertSP, conn, transaction);
                        cmdSP.Parameters.AddWithValue("@Ten", txtTenSP.Text);
                        cmdSP.Parameters.AddWithValue("@MaTH", ddlThuongHieu.SelectedValue);
                        cmdSP.Parameters.AddWithValue("@MaDT", ddlDoTuoi.SelectedValue);
                        cmdSP.Parameters.AddWithValue("@MoTa", txtMoTa.Text);
                        maSanPham = Convert.ToInt32(cmdSP.ExecuteScalar());

                        // 2. Insert BienThe
                        string sqlInsertBT = @"INSERT INTO BienTheSanPham (MaSanPham, TenBienThe, GiaBan, SoLuongTon) 
                                               VALUES (@MaSP, N'Tiêu chuẩn', @Gia, @Ton)";
                        SqlCommand cmdBT = new SqlCommand(sqlInsertBT, conn, transaction);
                        cmdBT.Parameters.AddWithValue("@MaSP", maSanPham);
                        cmdBT.Parameters.AddWithValue("@Gia", decimal.Parse(txtGia.Text));
                        cmdBT.Parameters.AddWithValue("@Ton", int.Parse(txtTonKho.Text));
                        cmdBT.ExecuteNonQuery();

                        // 3. Insert Anh Chính
                        string sqlInsertAnh = @"INSERT INTO AnhSanPham (MaSanPham, DuongDanAnh, LaAnhChinh) 
                                                VALUES (@MaSP, @Anh, 1)";
                        SqlCommand cmdAnh = new SqlCommand(sqlInsertAnh, conn, transaction);
                        cmdAnh.Parameters.AddWithValue("@MaSP", maSanPham);
                        cmdAnh.Parameters.AddWithValue("@Anh", finalImagePath);
                        cmdAnh.ExecuteNonQuery();
                    }

                    // --- XỬ LÝ ALBUM ẢNH PHỤ (Nằm TRONG Transaction để an toàn) ---
                    if (fileUploadAlbum.HasFiles)
                    {
                        string folderPath = Server.MapPath("~/Images/Products/");
                        if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                        foreach (HttpPostedFile uploadedFile in fileUploadAlbum.PostedFiles)
                        {
                            string ext = Path.GetExtension(uploadedFile.FileName).ToLower();
                            if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                            {
                                string albumFileName = "album_" + DateTime.Now.Ticks + "_" + Guid.NewGuid().ToString().Substring(0, 5) + ext;
                                string albumPath = Path.Combine(folderPath, albumFileName);
                                uploadedFile.SaveAs(albumPath);

                                // Insert vào DB với LaAnhChinh = 0
                                string sqlInsertAlbum = "INSERT INTO AnhSanPham (MaSanPham, DuongDanAnh, LaAnhChinh) VALUES (@MaSP, @Anh, 0)";
                                SqlCommand cmdAlbum = new SqlCommand(sqlInsertAlbum, conn, transaction);
                                // Lúc này biến maSanPham đã CÓ GIÁ TRỊ (do nằm cùng khối lệnh)
                                cmdAlbum.Parameters.AddWithValue("@MaSP", maSanPham);
                                cmdAlbum.Parameters.AddWithValue("@Anh", albumFileName);
                                cmdAlbum.ExecuteNonQuery();
                            }
                        }
                    }

                    // Commit xong -> Gán cờ thành công
                    transaction.Commit();
                    isSuccess = true;
                }
                catch (Exception ex)
                {
                    if (!isSuccess) transaction.Rollback();
                    lblError.Text = "Lỗi: " + ex.Message;
                    lblError.CssClass = "alert alert-danger";
                }
            }

            // --- 3. CHUYỂN HƯỚNG (Nằm ngoài khối using/transaction) ---
            if (isSuccess)
            {
                Response.Redirect("ManageProducts.aspx");
            }
        }

        // 4. Load Album Ảnh Phụ
        private void LoadAlbum(string id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT MaAnh, DuongDanAnh FROM AnhSanPham WHERE MaSanPham = @MaSP AND LaAnhChinh = 0";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", id);

                conn.Open();
                rptAlbum.DataSource = cmd.ExecuteReader();
                rptAlbum.DataBind();
            }
        }

        // 5. Xóa ảnh phụ
        protected void rptAlbum_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteImage")
            {
                int maAnh = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    string sql = "DELETE FROM AnhSanPham WHERE MaAnh = @MaAnh";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@MaAnh", maAnh);
                    cmd.ExecuteNonQuery();
                }

                // Load lại danh sách ảnh sau khi xóa
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id)) LoadAlbum(id);
            }
        }
    }
}