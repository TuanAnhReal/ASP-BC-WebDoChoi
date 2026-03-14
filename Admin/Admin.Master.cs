using System;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using WebDoChoi.Models;

namespace WebDoChoi.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Kiểm tra đăng nhập
            if (Session["KhachHang"] == null)
            {
                // Xóa Cookie cũ để sạch sẽ
                FormsAuthentication.SignOut();
                Response.Redirect("~/Login.aspx");
                return;
            }
            else
            {
                // 2. Kiểm tra quyền Admin
                UserSession user = (UserSession)Session["KhachHang"];
                if (user.VaiTro != "Admin")
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
            LoadActive();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // 1. Xóa Session
            Session.Abandon();
            // 2. Xóa Cookie xác thực Forms
            FormsAuthentication.SignOut();
            // 3. Về trang đăng nhập
            Response.Redirect("~/Login.aspx");
        }
        private void LoadActive()
        {
            string page = System.IO.Path.GetFileName(Request.Url.AbsolutePath);

            switch (page)
            {
                case "Dashboard.aspx":
                    SetActive(lnkDashboard);
                    break;
                case "ManageOrders.aspx":
                    SetActive(lnkManageOrders);
                    break;

                case "ManageProducts.aspx":
                    SetActive(lnkManageProducts);
                    break;
                case "ManageCustomers.aspx":
                    SetActive(lnkManageCustomers);
                    break;
                case "ManageBrands.aspx":
                    SetActive(lnkManageBrands);
                    break;
                case "ManageProductGroups.aspx":
                    SetActive(lnkManageProductGroups);
                    break;
                case "ManageBanners.aspx":
                    SetActive(lnkManageBanners);
                    break;
                case "ManageReviews.aspx":
                    SetActive(lnkManageReviews);
                    break;
            }
        }
        void SetActive(HtmlAnchor link)
        {
            link.Attributes["class"] += " active fw-bold bg-warning text-dark rounded";
        }
    }
}