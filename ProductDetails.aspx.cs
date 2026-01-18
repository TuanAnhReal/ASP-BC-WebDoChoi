using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Web;
using System.Web.UI;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;
        int currentMaThuongHieu = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id) || !int.TryParse(id, out int maSP))
                {
                    Response.Redirect("Default.aspx");
                    return;
                }

                LoadProductInfo(maSP);
                LoadProductImages(maSP);

                if (currentMaThuongHieu > 0)
                {
                    LoadRelatedProducts(maSP, currentMaThuongHieu);
                }
            }
        }

        // 1. Load thông tin chi tiết sản phẩm
        private void LoadProductInfo(int maSP)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"
                    SELECT TOP 1 s.MaSanPham, s.TenSanPham, s.MaThuongHieu, s.MoTaChiTiet, 
                           th.TenThuongHieu,
                           ISNULL(b.GiaBan, 0) as GiaBan, 
                           ISNULL(b.SoLuongTon, 0) as SoLuongTon,
                           ISNULL(a.DuongDanAnh, '/Images/no-image.png') as AnhChinh
                    FROM SanPham s
                    LEFT JOIN ThuongHieu th ON s.MaThuongHieu = th.MaThuongHieu
                    OUTER APPLY (SELECT TOP 1 * FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    WHERE s.MaSanPham = @ID";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", maSP);
                conn.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    Page.Title = dr["TenSanPham"].ToString();
                    lblTenSP.Text = dr["TenSanPham"].ToString();
                    lblMaSP.Text = "#" + dr["MaSanPham"].ToString();
                    lblThuongHieu.Text = dr["TenThuongHieu"].ToString();

                    decimal gia = Convert.ToDecimal(dr["GiaBan"]);
                    lblGia.Text = gia > 0 ? string.Format("{0:N0} đ", gia) : "Liên hệ";

                    int tonKho = Convert.ToInt32(dr["SoLuongTon"]);
                    if (tonKho > 0)
                    {
                        lblTinhTrang.Text = "CÒN HÀNG";
                        lblTinhTrang.CssClass += " bg-success text-white";
                        btnAddToCart.Enabled = true;
                        txtSoLuong.Attributes["max"] = tonKho.ToString();
                    }
                    else
                    {
                        lblTinhTrang.Text = "HẾT HÀNG";
                        lblTinhTrang.CssClass += " bg-secondary text-white";
                        btnAddToCart.Enabled = false;
                        btnAddToCart.Text = "TẠM HẾT HÀNG";
                    }

                    // --- SỬA LỖI ẢNH LỚN TẠI ĐÂY ---
                    string imgFile = dr["AnhChinh"].ToString();
                    // Nếu tên file không bắt đầu bằng '/' (tức là chỉ có tên file như 'xe.jpg'), ta nối thêm đường dẫn vào
                    if (!imgFile.StartsWith("/"))
                    {
                        imgMain.ImageUrl = "~/Images/Products/" + imgFile;
                        imgThumbMain.ImageUrl = "~/Images/Products/" + imgFile;
                    }
                    else
                    {
                        // Nếu là '/Images/no-image.png' (mặc định từ SQL) thì giữ nguyên
                        imgMain.ImageUrl = imgFile;
                        imgThumbMain.ImageUrl = imgFile;
                    }
                    // -------------------------------

                    divMoTaChiTiet.InnerHtml = dr["MoTaChiTiet"].ToString();
                    string moTaFull = WebUtility.HtmlDecode(dr["MoTaChiTiet"].ToString());
                    lblMoTaNgan.Text = moTaFull.Length > 200 ? moTaFull.Substring(0, 200) + "..." : moTaFull;

                    currentMaThuongHieu = Convert.ToInt32(dr["MaThuongHieu"]);
                }
                else
                {
                    Response.Redirect("Default.aspx");
                }
            }
        }

        // 2. Load Album ảnh phụ
        private void LoadProductImages(int maSP)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // THÊM: "AND LaAnhChinh = 0" để không lấy ảnh chính nữa
                string sql = "SELECT DuongDanAnh FROM AnhSanPham WHERE MaSanPham = @ID AND LaAnhChinh = 0";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.SelectCommand.Parameters.AddWithValue("@ID", maSP);

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAlbum.DataSource = dt;
                rptAlbum.DataBind();
            }
        }

        // 3. Load Sản phẩm liên quan
        private void LoadRelatedProducts(int currentID, int brandID)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"
                    SELECT TOP 4 s.MaSanPham, s.TenSanPham, 
                           ISNULL(b.GiaBan, 0) as GiaBan,
                           ISNULL(a.DuongDanAnh, 'no-image.png') as HinhAnh
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    WHERE s.MaThuongHieu = @BrandID AND s.MaSanPham != @CurrentID AND s.TrangThai = 1
                    ORDER BY NEWID()";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@BrandID", brandID);
                cmd.Parameters.AddWithValue("@CurrentID", currentID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptLienQuan.DataSource = dt;
                rptLienQuan.DataBind();
            }
        }

        // 4. Xử lý Thêm vào giỏ hàng
        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (string.IsNullOrEmpty(id)) return;
            int maSP = int.Parse(id);
            int soLuongMua = int.Parse(txtSoLuong.Text);

            CartItem item = new CartItem();
            item.MaSanPham = maSP;
            item.SoLuong = soLuongMua;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT TOP 1 s.TenSanPham, ISNULL(b.GiaBan, 0) as GiaBan, 
                               ISNULL(a.DuongDanAnh, 'no-image.png') as HinhAnh
                               FROM SanPham s
                               OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
                               OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                               WHERE s.MaSanPham = @ID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", maSP);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    item.TenSanPham = dr["TenSanPham"].ToString();
                    item.GiaBan = Convert.ToDecimal(dr["GiaBan"]);
                    item.HinhAnh = dr["HinhAnh"].ToString();
                }
            }

            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart == null) cart = new List<CartItem>();

            CartItem existingItem = cart.Find(x => x.MaSanPham == maSP);
            if (existingItem != null)
            {
                existingItem.SoLuong += soLuongMua;
            }
            else
            {
                cart.Add(item);
            }

            Session["Cart"] = cart;
            Response.Redirect("Cart.aspx");
        }
    }
}