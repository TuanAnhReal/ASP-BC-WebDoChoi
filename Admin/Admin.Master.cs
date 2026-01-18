using System;
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
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                // 2. Kiểm tra quyền Admin
                UserSession user = (UserSession)Session["KhachHang"];
                if (user.VaiTro != "Admin")
                {
                    // Nếu là khách thường mà cố vào -> Đá về trang chủ
                    Response.Redirect("~/Default.aspx");
                }
            }
        }
    }
}