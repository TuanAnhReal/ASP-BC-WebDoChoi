using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebDoChoi
{
    public partial class Default : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Load danh sách thương hiệu vào Sidebar
                LoadSidebarThuongHieu();

                // 2. Đồng bộ URL (nếu có ?brand=.. hoặc ?q=..) vào bộ lọc
                SyncUrlToFilter();

                // 3. Tải sản phẩm (Lần đầu tiên)
                LoadProducts();
            }
        }

        // --- 1. Load Sidebar CheckBoxList ---
        private void LoadSidebarThuongHieu()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT MaThuongHieu, TenThuongHieu FROM ThuongHieu";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cblThuongHieu.DataSource = dt;
                cblThuongHieu.DataTextField = "TenThuongHieu";
                cblThuongHieu.DataValueField = "MaThuongHieu";
                cblThuongHieu.DataBind();
            }
        }

        // --- 2. Đồng bộ URL vào Bộ lọc ---
        private void SyncUrlToFilter()
        {
            // Nếu bấm từ Menu Navbar (?brand=1) -> Tự động tích vào ô Checkbox tương ứng
            string brandId = Request.QueryString["brand"];
            if (!string.IsNullOrEmpty(brandId))
            {
                foreach (ListItem item in cblThuongHieu.Items)
                {
                    if (item.Value == brandId)
                    {
                        item.Selected = true;
                    }
                }
            }

            // Nếu tìm kiếm (?q=lego) -> Hiện thông báo
            string query = Request.QueryString["q"];
            if (!string.IsNullOrEmpty(query))
            {
                lblKetQuaTimKiem.Text = "Kết quả tìm kiếm cho: " + Server.HtmlEncode(query);
            }
        }

        // --- 3. Hàm Lọc & Hiển thị Sản phẩm (QUAN TRỌNG NHẤT) ---
        private void LoadProducts()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Câu lệnh SQL cơ bản
                string sql = @"
                    SELECT s.MaSanPham, s.TenSanPham, 
                           ISNULL(b.GiaBan, 0) as GiaBan,
                           ISNULL(a.DuongDanAnh, 'no-image.png') as HinhAnh
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    WHERE s.TrangThai = 1 ";

                // A. Lọc theo Thương hiệu (CheckBoxList)
                List<string> selectedBrands = new List<string>();
                foreach (ListItem item in cblThuongHieu.Items)
                {
                    if (item.Selected) selectedBrands.Add(item.Value);
                }
                if (selectedBrands.Count > 0)
                {
                    string listID = string.Join(",", selectedBrands);
                    sql += " AND s.MaThuongHieu IN (" + listID + ") ";
                }

                // B. Lọc theo Giá (RadioButtonList - rblGia)
                // Value 1: < 500k | Value 2: 500k-1tr | Value 3: > 1tr
                string priceRange = rblGia.SelectedValue;
                switch (priceRange)
                {
                    case "1": // Dưới 500.000
                        sql += " AND b.GiaBan < 500000 ";
                        break;
                    case "2": // Từ 500.000 - 1.000.000
                        sql += " AND b.GiaBan >= 500000 AND b.GiaBan <= 1000000 ";
                        break;
                    case "3": // Trên 1.000.000
                        sql += " AND b.GiaBan > 1000000 ";
                        break;
                    default: // "0" hoặc null -> Không lọc giá
                        break;
                }

                // C. Lọc theo Từ khóa tìm kiếm (URL ?q=...)
                string q = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(q))
                {
                    sql += " AND s.TenSanPham LIKE @Keyword ";
                }

                // D. Sắp xếp (DropDownList - ddlSort)
                string sort = ddlSort.SelectedValue;
                switch (sort)
                {
                    case "price_asc":
                        sql += " ORDER BY b.GiaBan ASC";
                        break;
                    case "price_desc":
                        sql += " ORDER BY b.GiaBan DESC";
                        break;
                    case "new":
                    default:
                        // Sắp xếp theo ID giảm dần (mới nhất lên đầu)
                        sql += " ORDER BY s.MaSanPham DESC";
                        break;
                }

                // --- Thực thi ---
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(q))
                {
                    cmd.Parameters.AddWithValue("@Keyword", "%" + q + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                lvSanPham.DataSource = dt;
                lvSanPham.DataBind();

                // Cập nhật số lượng tìm thấy
                lblKetQuaTimKiem.Text = "Tìm thấy " + dt.Rows.Count + " sản phẩm";
            }
        }

        // Sự kiện: Bấm nút "ÁP DỤNG LỌC"
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            // Khi bấm nút này, code sẽ tự đọc trạng thái của CheckBoxList và RadioButtonList
            // để nối chuỗi SQL trong hàm LoadProducts
            LoadProducts();
        }

        // Sự kiện: Thay đổi kiểu Sắp xếp (AutoPostBack)
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }
    }
}