using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebDoChoi
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            //Xóa Session Khách hàng
            Session.Remove("KhachHang");

            //Xóa Session Giỏ hàng (Tùy chọn: Nếu muốn logout là mất giỏ hàng)
            Session.Remove("Cart");

            //Xóa toàn bộ Session (Cách triệt để nhất)
            // Session.Abandon(); 

            //Tải lại trang chủ
            Response.Redirect("Default.aspx");
        }
    }
}