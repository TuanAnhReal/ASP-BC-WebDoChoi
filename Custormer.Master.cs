using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class Customer : System.Web.UI.MasterPage
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserStatus();
                LoadCartBadge();
                LoadMenuThuongHieu();
            }
        }

        // 1. Kiểm tra trạng thái Đăng nhập
        private void LoadUserStatus()
        {
            if (Session["KhachHang"] != null)
            {
                phUser.Visible = true;
                phGuest.Visible = false;

                UserSession user = (UserSession)Session["KhachHang"];
                lblTenKhach.Text = user.HoTen;
            }
            else
            {
                phUser.Visible = false;
                phGuest.Visible = true;
            }
        }

        // 2. Hiển thị số lượng giỏ hàng (Badge)
        private void LoadCartBadge()
        {
            if (Session["Cart"] != null)
            {
                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                // Kiểm tra null lần nữa cho chắc
                if (cart != null)
                {
                    int totalQuantity = cart.Sum(item => item.SoLuong);
                    lblCartCount.Text = totalQuantity.ToString();
                }
                else
                {
                    lblCartCount.Text = "0";
                }
            }
            else
            {
                lblCartCount.Text = "0";
            }
        }

        // 3. Load Menu Thương Hiệu từ Database
        private void LoadMenuThuongHieu()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    string sql = "SELECT MaThuongHieu, TenThuongHieu FROM ThuongHieu ORDER BY TenThuongHieu";
                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptMenuThuongHieu.DataSource = dt;
                    rptMenuThuongHieu.DataBind();
                }
            }
            catch
            {
                // Nếu lỗi DB thì menu rỗng, không làm crash web
            }
        }

        // 4. Sự kiện Tìm kiếm
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                // Chuyển hướng sang trang Default kèm từ khóa
                Response.Redirect("~/Default.aspx?q=" + Server.UrlEncode(keyword));
            }
        }

        // 5. Sự kiện Đăng xuất
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("KhachHang");
            Session.Remove("Cart"); // Nên xóa luôn giỏ hàng khi đăng xuất cho bảo mật
            Response.Redirect("~/Default.aspx");
        }
    }
}