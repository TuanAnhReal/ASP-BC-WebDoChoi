using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

namespace WebDoChoi
{
    public partial class Default : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;
        const int PAGE_SIZE = 6;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSidebarNhom();
                LoadSidebarThuongHieu();
                SyncUrlToFilter();
                LoadBanners();

                // Gọi hàm load sản phẩm (phiên bản mới có phân trang)
                LoadProducts();
            }
        }

        // --- CÁC HÀM LOAD DỮ LIỆU PHỤ (Banner, Sidebar...) GIỮ NGUYÊN ---
        private void LoadBanners()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT * FROM QuangCao WHERE HienThi = 1 ORDER BY ThuTu ASC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptBanner.DataSource = dt;
                rptBanner.DataBind();
            }
        }

        private void LoadSidebarNhom()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM NhomSanPham", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                cblNhom.DataSource = dt;
                cblNhom.DataBind();
            }
        }

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

        private void SyncUrlToFilter()
        {
            string groupID = Request.QueryString["group"];
            if (!string.IsNullOrEmpty(groupID))
            {
                ListItem item = cblNhom.Items.FindByValue(groupID);
                if (item != null) item.Selected = true;
            }

            string brandId = Request.QueryString["brand"];
            if (!string.IsNullOrEmpty(brandId))
            {
                foreach (ListItem item in cblThuongHieu.Items)
                {
                    if (item.Value == brandId) item.Selected = true;
                }
            }

            string query = Request.QueryString["q"];
            if (!string.IsNullOrEmpty(query))
            {
                lblKetQuaTimKiem.Text = "Kết quả tìm kiếm cho: " + Server.HtmlEncode(query);
            }

            // Đồng bộ Giá
            string price = Request.QueryString["price"];
            if (!string.IsNullOrEmpty(price))
            {
                // Bỏ chọn cũ
                rblGia.ClearSelection();
                // Chọn mới theo URL
                ListItem item = rblGia.Items.FindByValue(price);
                if (item != null) item.Selected = true;
            }

            // Đồng bộ Sắp xếp
            string sort = Request.QueryString["sort"];
            if (!string.IsNullOrEmpty(sort))
            {
                ddlSort.ClearSelection();
                ListItem item = ddlSort.Items.FindByValue(sort);
                if (item != null) item.Selected = true;
            }
        }

        // --- SỰ KIỆN NÚT BẤM ---
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string url = BuildFilterUrl();
            Response.Redirect(url);
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            string url = BuildFilterUrl();
            Response.Redirect(url);
        }

        // --- HÀM CHÍNH: LOAD SẢN PHẨM (Đã thay thế hàm cũ bằng logic FilterProducts) ---
        private void LoadProducts()
        {
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                int.TryParse(Request.QueryString["page"], out pageIndex);
            }
            if (pageIndex < 1) pageIndex = 1;

            int skip = (pageIndex - 1) * PAGE_SIZE;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // 1. Xây dựng điều kiện WHERE chung
                string sqlCondition = " WHERE s.TrangThai = 1 ";
                List<SqlParameter> parameters = new List<SqlParameter>();

                // Lọc Nhóm
                List<string> selectedGroups = new List<string>();
                foreach (ListItem item in cblNhom.Items)
                    if (item.Selected) selectedGroups.Add(item.Value);
                if (selectedGroups.Count > 0)
                    sqlCondition += " AND s.MaNhom IN (" + string.Join(",", selectedGroups) + ") ";

                // Lọc Thương hiệu
                List<string> selectedBrands = new List<string>();
                foreach (ListItem item in cblThuongHieu.Items)
                    if (item.Selected) selectedBrands.Add(item.Value);
                if (selectedBrands.Count > 0)
                    sqlCondition += " AND s.MaThuongHieu IN (" + string.Join(",", selectedBrands) + ") ";

                // Lọc Từ khóa
                string keyword = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(keyword))
                {
                    sqlCondition += " AND s.TenSanPham LIKE @Keyword ";
                    parameters.Add(new SqlParameter("@Keyword", "%" + keyword + "%"));
                }

                // Lọc Giá
                string priceOption = rblGia.SelectedValue;
                switch (priceOption)
                {
                    case "1": sqlCondition += " AND b.GiaBan < 500000 "; break;
                    case "2": sqlCondition += " AND b.GiaBan >= 500000 AND b.GiaBan <= 1000000 "; break;
                    case "3": sqlCondition += " AND b.GiaBan > 1000000 "; break;
                }

                // 2. QUERY 1: Đếm tổng số dòng (Count)
                string sqlCount = @"
                    SELECT COUNT(*)
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham ORDER BY GiaBan ASC) b
                    " + sqlCondition;

                SqlCommand cmdCount = new SqlCommand(sqlCount, conn);
                cmdCount.Parameters.AddRange(parameters.ToArray()); // Copy tham số

                conn.Open();
                int totalRows = (int)cmdCount.ExecuteScalar();

                // 3. QUERY 2: Lấy dữ liệu phân trang
                string sqlSort = "";
                string sortOption = ddlSort.SelectedValue;
                switch (sortOption)
                {
                    case "price_asc": sqlSort = " ORDER BY b.GiaBan ASC, s.MaSanPham DESC"; break;
                    case "price_desc": sqlSort = " ORDER BY b.GiaBan DESC, s.MaSanPham DESC"; break;
                    case "new":
                    default: sqlSort = " ORDER BY s.MaSanPham DESC"; break; // Sửa lại: Sắp xếp theo ID giảm dần là chuẩn nhất cho 'Mới nhất'
                }

                string sqlData = @"
                    SELECT s.MaSanPham, s.TenSanPham, 
                           ISNULL(b.GiaBan, 0) AS GiaBan,
                           ISNULL(a.DuongDanAnh, '/Images/no-image.png') AS HinhAnh
                    FROM SanPham s
                    OUTER APPLY (SELECT TOP 1 GiaBan FROM BienTheSanPham WHERE MaSanPham = s.MaSanPham ORDER BY GiaBan ASC) b
                    OUTER APPLY (SELECT TOP 1 DuongDanAnh FROM AnhSanPham WHERE MaSanPham = s.MaSanPham AND LaAnhChinh = 1) a
                    " + sqlCondition + sqlSort +
                    " OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY";

                SqlCommand cmdData = new SqlCommand(sqlData, conn);

                // Add lại tham số lọc
                // Lưu ý: Không thể dùng lại mảng parameters cũ trực tiếp cho command mới nếu nó đã gắn vào command khác
                // Nên ta clear và add lại từ đầu hoặc clone. Cách đơn giản nhất ở đây là add lại:
                foreach (var p in parameters)
                {
                    cmdData.Parameters.Add(new SqlParameter(p.ParameterName, p.Value));
                }

                cmdData.Parameters.AddWithValue("@Skip", skip);
                cmdData.Parameters.AddWithValue("@Take", PAGE_SIZE);

                SqlDataAdapter da = new SqlDataAdapter(cmdData);
                DataTable dt = new DataTable();
                da.Fill(dt);

                lvSanPham.DataSource = dt;
                lvSanPham.DataBind();

                lblKetQuaTimKiem.Text = $"Tìm thấy {totalRows} sản phẩm";

                // 4. Render HTML phân trang
                RenderPagination(totalRows, PAGE_SIZE, pageIndex);
            }
        }

        private void RenderPagination(int totalRows, int pageSize, int currentPage)
        {
            if (totalRows <= pageSize)
            {
                ltrPhanTrang.Text = "";
                return;
            }

            int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
            string html = "";

            // Nút Prev: Chỉ hiển thị khi lớn hơn trang 1 (Ẩn hẳn ở trang 1 giống thiết kế)
            if (currentPage > 1)
            {
                html += $"<li class='page-item btn-prev'><a class='page-link' href='{GetUrlWithPage(currentPage - 1)}'>&#9668;</a></li>"; // Icon tam giác hướng trái
            }

            // Các nút số
            for (int i = 1; i <= totalPages; i++)
            {
                if (i == currentPage)
                    html += $"<li class='page-item active'><span class='page-link'>{i}</span></li>";
                else
                    html += $"<li class='page-item'><a class='page-link' href='{GetUrlWithPage(i)}'>{i}</a></li>";
            }

            // Nút Next: Chỉ hiển thị khi chưa tới trang cuối
            // Thêm class 'btn-next' để CSS nhận diện chính xác
            if (currentPage < totalPages)
            {
                html += $"<li class='page-item btn-next'><a class='page-link' href='{GetUrlWithPage(currentPage + 1)}'>&#9658;</a></li>"; // Icon tam giác hướng phải giống ảnh
            }

            ltrPhanTrang.Text = html;
        }

        private string GetUrlWithPage(int newPage)
        {
            NameValueCollection query = HttpUtility.ParseQueryString(Request.QueryString.ToString());
            query.Set("page", newPage.ToString());
            return Request.Url.AbsolutePath + "?" + query.ToString();
        }
        // Hàm thu thập thông tin từ UI và tạo URL
        private string BuildFilterUrl()
        {
            // Sử dụng ParseQueryString để thao tác tham số URL dễ dàng
            var query = HttpUtility.ParseQueryString(string.Empty);

            // 1. Lấy Nhóm (Group)
            List<string> selectedGroups = new List<string>();
            foreach (ListItem item in cblNhom.Items)
            {
                if (item.Selected) selectedGroups.Add(item.Value);
            }
            if (selectedGroups.Count > 0)
            {
                query["group"] = string.Join(",", selectedGroups); // URL sẽ là group=1,2
            }

            // 2. Lấy Thương hiệu (Brand)
            List<string> selectedBrands = new List<string>();
            foreach (ListItem item in cblThuongHieu.Items)
            {
                if (item.Selected) selectedBrands.Add(item.Value);
            }
            if (selectedBrands.Count > 0)
            {
                query["brand"] = string.Join(",", selectedBrands);
            }

            // 3. Lấy Giá
            if (rblGia.SelectedValue != "0" && !string.IsNullOrEmpty(rblGia.SelectedValue))
            {
                query["price"] = rblGia.SelectedValue;
            }

            // 4. Lấy Từ khóa tìm kiếm (giữ lại nếu đang tìm kiếm)
            if (!string.IsNullOrEmpty(Request.QueryString["q"]))
            {
                query["q"] = Request.QueryString["q"];
            }

            // 5. Lấy Sắp xếp (Sort) - Quan trọng
            // Nếu sort = "new" (mặc định) thì không cần để lên URL cho gọn
            if (ddlSort.SelectedValue != "new")
            {
                query["sort"] = ddlSort.SelectedValue;
            }

            // Lưu ý: Khi bấm Lọc thì luôn reset về Page 1 (không cần thêm param page)

            return "Default.aspx?" + query.ToString();
        }
    }
}