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
    public partial class Register : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_Web_Do_Choi_Conn"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            //Kiểm tra xác nhận mật khẩu
            if (txtMatKhau.Text != txtXacNhan.Text)
            {
                lblError.Text = "Mật khẩu xác nhận không khớp!";
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                //Kiểm tra Email đã tồn tại chưa
                string checkSql = "SELECT COUNT(*) FROM KhachHang WHERE Email = @Email";
                SqlCommand cmdCheck = new SqlCommand(checkSql, conn);
                cmdCheck.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                int exists = (int)cmdCheck.ExecuteScalar();
                if (exists > 0)
                {
                    lblError.Text = "Email này đã được sử dụng!";
                    return;
                }

                //Mã hóa mật khẩu
                string passwordHash = SecurityUtils.HashPassword(txtMatKhau.Text.Trim());

                //Thêm vào Database
                string insertSql = @"INSERT INTO KhachHang (HoTen, Email, SoDienThoai, DiaChi, MatKhau) 
                                     VALUES (@HoTen, @Email, @SDT, @DiaChi, @MatKhau)";

                SqlCommand cmdInsert = new SqlCommand(insertSql, conn);
                cmdInsert.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
                cmdInsert.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmdInsert.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
                cmdInsert.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                cmdInsert.Parameters.AddWithValue("@MatKhau", passwordHash);

                cmdInsert.ExecuteNonQuery();

                //Chuyển hướng sang trang đăng nhập
                Response.Redirect("Login.aspx");
            }
        }
    }
}