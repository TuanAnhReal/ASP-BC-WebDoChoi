using System;
using System.Data.SqlClient;
using System.Configuration;
using WebDoChoi.Models; // Import namespace chứa UserSession và SecurityUtils

namespace WebDoChoi
{
    public partial class Profile : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Kiểm tra đăng nhập
            if (Session["KhachHang"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        // Hàm load dữ liệu ban đầu
        private void LoadProfile()
        {
            UserSession user = (UserSession)Session["KhachHang"];
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Lấy thông tin chi tiết từ DB (đề phòng Session bị cũ)
                string sql = "SELECT * FROM KhachHang WHERE MaKhachHang = @MaKH";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaKH", user.MaKhachHang);
                conn.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtEmail.Text = dr["Email"].ToString();
                    txtHoTen.Text = dr["HoTen"].ToString();
                    txtSDT.Text = dr["SoDienThoai"].ToString();
                    txtDiaChi.Text = dr["DiaChi"].ToString();
                }
            }
        }

        // --- SỰ KIỆN 1: CẬP NHẬT THÔNG TIN CHUNG ---
        protected void btnUpdateInfo_Click(object sender, EventArgs e)
        {
            UserSession user = (UserSession)Session["KhachHang"];

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = @"UPDATE KhachHang 
                               SET HoTen = @HoTen, SoDienThoai = @SDT, DiaChi = @DiaChi 
                               WHERE MaKhachHang = @MaKH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
                cmd.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
                cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                cmd.Parameters.AddWithValue("@MaKH", user.MaKhachHang);

                int rows = cmd.ExecuteNonQuery();
                if (rows > 0)
                {
                    lblMsgInfo.Text = "Cập nhật thông tin thành công!";
                    lblMsgInfo.CssClass = "d-block mb-3 fw-bold text-success";

                    // QUAN TRỌNG: Cập nhật lại Session để Header hiển thị tên mới ngay lập tức
                    user.HoTen = txtHoTen.Text.Trim();
                    // Nếu trong UserSession có lưu SĐT hay Địa chỉ thì cập nhật luôn

                    Session["KhachHang"] = user; // Gán ngược lại vào Session
                }
                else
                {
                    lblMsgInfo.Text = "Có lỗi xảy ra, vui lòng thử lại.";
                    lblMsgInfo.CssClass = "d-block mb-3 fw-bold text-danger";
                }
            }
        }

        // --- SỰ KIỆN 2: ĐỔI MẬT KHẨU ---
        protected void btnChangePass_Click(object sender, EventArgs e)
        {
            UserSession user = (UserSession)Session["KhachHang"];
            string oldPassHash = SecurityUtils.HashPassword(txtOldPass.Text.Trim());

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                // Bước 1: Kiểm tra mật khẩu cũ có đúng không
                string sqlCheck = "SELECT COUNT(*) FROM KhachHang WHERE MaKhachHang = @MaKH AND MatKhau = @OldPass";
                SqlCommand cmdCheck = new SqlCommand(sqlCheck, conn);
                cmdCheck.Parameters.AddWithValue("@MaKH", user.MaKhachHang);
                cmdCheck.Parameters.AddWithValue("@OldPass", oldPassHash);

                int count = (int)cmdCheck.ExecuteScalar();
                if (count == 0)
                {
                    lblMsgPass.Text = "Mật khẩu hiện tại không đúng!";
                    lblMsgPass.CssClass = "d-block mb-3 fw-bold text-danger";
                    return;
                }

                // Bước 2: Cập nhật mật khẩu mới
                string newPassHash = SecurityUtils.HashPassword(txtNewPass.Text.Trim());

                string sqlUpdate = "UPDATE KhachHang SET MatKhau = @NewPass WHERE MaKhachHang = @MaKH";
                SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, conn);
                cmdUpdate.Parameters.AddWithValue("@NewPass", newPassHash);
                cmdUpdate.Parameters.AddWithValue("@MaKH", user.MaKhachHang);

                cmdUpdate.ExecuteNonQuery();

                lblMsgPass.Text = "Đổi mật khẩu thành công!";
                lblMsgPass.CssClass = "d-block mb-3 fw-bold text-success";

                // Clear các ô nhập liệu
                txtOldPass.Text = "";
                txtNewPass.Text = "";
                txtConfirmPass.Text = "";
            }
        }
    }
}