using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class Login : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_Web_Do_Choi_Conn"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string pass = txtMatKhau.Text.Trim();

            //Mã hóa mật khẩu người dùng nhập vào để so sánh với DB
            string passHash = SecurityUtils.HashPassword(pass);

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "SELECT MaKhachHang, HoTen, Email FROM KhachHang WHERE Email = @Email AND MatKhau = @MatKhau";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@MatKhau", passHash);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    //Đăng nhập thành công -> Lưu vào Class UserSession
                    UserSession user = new UserSession();
                    user.MaKhachHang = Convert.ToInt32(dr["MaKhachHang"]);
                    user.HoTen = dr["HoTen"].ToString();
                    user.Email = dr["Email"].ToString();

                    //Lưu object vào Session
                    Session["KhachHang"] = user;

                    //Chuyển hướng (Về trang chủ hoặc trang trước đó)
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    lblError.Text = "Sai email hoặc mật khẩu. Vui lòng thử lại!";
                }
            }
        }
    }
}