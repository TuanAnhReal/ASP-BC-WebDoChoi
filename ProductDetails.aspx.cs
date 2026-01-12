using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        // Lấy chuỗi kết nối từ Web.config
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                LoadChiTiet(id);
                LoadAlbumAnh(id);
            }
        }

        private void LoadChiTiet(string id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
            string sql = @"
            SELECT s.*, th.TenThuongHieu, dt.KhoangDoTuoi, b.GiaBan, a.DuongDanAnh
            FROM SanPham s
            LEFT JOIN ThuongHieu th ON s.MaThuongHieu = th.MaThuongHieu
            LEFT JOIN DoTuoi dt ON s.MaDoTuoi = dt.MaDoTuoi
            OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
            OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
            WHERE s.MaSanPham = @MaSP";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTenSP.InnerText = dr["TenSanPham"].ToString();
                    lblThuongHieu.InnerText = dr["TenThuongHieu"].ToString();
                    lblDoTuoi.InnerText = dr["KhoangDoTuoi"].ToString();
                    lblGia.InnerText = DinhDangTien(dr["GiaBan"]);
                    divMoTa.InnerHtml = dr["MoTaChiTiet"].ToString();

                    string tenAnh = dr["DuongDanAnh"].ToString();
                    if (!string.IsNullOrEmpty(tenAnh))
                    {
                        imgMain.ImageUrl = "~/Images/Products/" + tenAnh;
                    }
                    else
                    {
                        imgMain.ImageUrl = "~/Images/logo.png";
                    }
                }
            }
        }

        private void LoadAlbumAnh(string id)
        {
            // Sử dụng lại biến strConn đã khai báo ở đầu class
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Câu lệnh SQL lấy tất cả ảnh của sản phẩm đó
                string sql = "SELECT DuongDanAnh FROM AnhSanPham WHERE MaSanPham = @MaSP";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@MaSP", id);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Gán dữ liệu vào Repeater
                        rptAlbum.DataSource = dt;
                        rptAlbum.DataBind();
                    }
                }
            }
        }

        public static string DinhDangTien(object gia)
        {
            if (gia == DBNull.Value || gia == null) return "Liên hệ";

            decimal amount = Convert.ToDecimal(gia);
            return string.Format(System.Globalization.CultureInfo.GetCultureInfo("vi-VN"), "{0:C0}", amount);
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (string.IsNullOrEmpty(id)) return;

            int maSP = int.Parse(id);

            //Lấy thông tin sản phẩm từ Database
            CartItem item = LayThongTinSanPham(maSP);

            if (item != null)
            {
                //Lấy giỏ hàng từ Session
                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                }

                //Kiểm tra sản phẩm đã có trong giỏ chưa
                CartItem sanPhamDaCo = cart.Find(x => x.MaSanPham == maSP);
                if (sanPhamDaCo != null)
                {
                    sanPhamDaCo.SoLuong++;
                }
                else
                {
                    cart.Add(item); // Chưa có thì thêm mới
                }

                //Cập nhật lại Session
                Session["Cart"] = cart;

                //Chuyển hướng sang trang Giỏ hàng
                Response.Redirect("Cart.aspx");
            }
        }

        // Hàm hỗ trợ lấy dữ liệu nhanh
        private CartItem LayThongTinSanPham(int id)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Lấy giá của biến thể rẻ nhất và ảnh chính
                string sql = @"
                    SELECT TOP 1 s.TenSanPham, ISNULL(b.GiaBan, 0) as GiaBan, a.DuongDanAnh
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham ORDER BY GiaBan ASC) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    WHERE s.MaSanPham = @MaSP";
                
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    return new CartItem()
                    {
                        MaSanPham = id,
                        TenSanPham = dr["TenSanPham"].ToString(),
                        GiaBan = Convert.ToDecimal(dr["GiaBan"]),
                        HinhAnh = dr["DuongDanAnh"] != DBNull.Value ? dr["DuongDanAnh"].ToString() : "/Images/no-image.png",
                        SoLuong = 1
                    };
                }
            }
            return null;
        }
    }
}