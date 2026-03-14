using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
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
            string vaitro = "";

            //Mã hóa mật khẩu người dùng nhập vào để so sánh với DB
            string passHash = SecurityUtils.HashPassword(pass);

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "SELECT MaKhachHang, HoTen, Email, VaiTro, TrangThai FROM KhachHang WHERE Email = @Email AND MatKhau = @MatKhau";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@MatKhau", passHash);
                cmd.Parameters.AddWithValue("@VaiTro", vaitro);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    // 1. KIỂM TRA TRẠNG THÁI TÀI KHOẢN
                    bool isActive = Convert.ToBoolean(dr["TrangThai"]); // Đọc cột TrangThai (True/False)

                    if (!isActive)
                    {
                        lblError.Text = "Tài khoản của bạn đã bị KHÓA. Vui lòng liên hệ Admin để được hỗ trợ.";
                        lblError.Visible = true;
                        return; // Dừng lại, không cho đăng nhập
                    }

                    // 1. Lưu thông tin vào Session (Để dùng hiển thị tên, lấy ID...)
                    UserSession user = new UserSession();
                    user.MaKhachHang = Convert.ToInt32(dr["MaKhachHang"]);
                    user.HoTen = dr["HoTen"].ToString();
                    user.Email = dr["Email"].ToString();
                    user.VaiTro = dr["VaiTro"].ToString(); // Quan trọng: Lấy vai trò Admin/KhachHang
                    Session["KhachHang"] = user;

                    // 2. Ghi nhận đăng nhập với ASP.NET (Để vượt qua Web.config)
                    // Tham số 1: Tên định danh (Email).
                    // Tham số 2: Remember Me (False: Đóng trình duyệt là mất, True: Lưu lâu dài).
                    FormsAuthentication.SetAuthCookie(user.Email, false);

                    // 3. Điều hướng phân quyền
                    if (user.VaiTro == "Admin")
                    {
                        Response.Redirect("~/Admin/Dashboard.aspx");
                    }
                    else
                    {
                        // Nếu trang trước đó yêu cầu login, dòng này sẽ đẩy về trang đó. 
                        // Nếu không, về Default.aspx.
                        Response.Redirect(FormsAuthentication.GetRedirectUrl(user.Email, false));
                    }
                }
                else
                {
                    lblError.Text = "Sai email hoặc mật khẩu. Vui lòng thử lại!";
                    lblError.Visible = true;
                }
            }
        }
    }
}