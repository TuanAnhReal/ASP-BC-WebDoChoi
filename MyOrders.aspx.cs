using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using WebDoChoi.Models; // Import namespace UserSession

namespace WebDoChoi
{
    public partial class MyOrders : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Kiểm tra đăng nhập
                if (Session["KhachHang"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadDonHang();
            }
        }

        private void LoadDonHang()
        {
            // Lấy User ID từ Session
            UserSession user = (UserSession)Session["KhachHang"];

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Chỉ lấy đơn hàng của Khách Hàng này
                string sql = "SELECT * FROM DonHang WHERE MaKhachHang = @MaKH ORDER BY NgayDat DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaKH", user.MaKhachHang);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDonHang.DataSource = dt;
                gvDonHang.DataBind();
            }
        }

        // Xử lý màu sắc trạng thái
        protected void gvDonHang_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("lblTrangThai");
                if (lbl != null)
                {
                    string status = lbl.Text;
                    switch (status)
                    {
                        case "Mới":
                            lbl.CssClass += " bg-info text-dark"; // Màu xanh nhạt
                            break;
                        case "Đang giao":
                            lbl.CssClass += " bg-warning text-dark"; // Màu vàng
                            break;
                        case "Hoàn tất":
                            lbl.CssClass += " bg-success"; // Màu xanh lá
                            break;
                        case "Đã hủy":
                            lbl.CssClass += " bg-secondary"; // Màu xám
                            break;
                        default:
                            lbl.CssClass += " bg-secondary";
                            break;
                    }
                }
            }
        }
    }
}