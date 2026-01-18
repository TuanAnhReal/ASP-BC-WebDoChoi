using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebDoChoi.Admin
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDonHang();
            }
        }

        private void LoadDonHang()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // JOIN bảng DonHang và KhachHang để lấy tên khách
                string sql = @"SELECT d.MaDonHang, d.NgayDat, d.TongTien, d.TrangThaiDonHang, k.HoTen 
                               FROM DonHang d 
                               JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang 
                               ORDER BY d.NgayDat DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDonHang.DataSource = dt;
                gvDonHang.DataBind();
            }
        }

        // Sự kiện đổ dữ liệu vào từng dòng: Để set đúng giá trị cho DropDownList
        protected void gvDonHang_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Lấy trạng thái từ nguồn dữ liệu (DataTable)
                string trangThai = DataBinder.Eval(e.Row.DataItem, "TrangThaiDonHang").ToString();

                // Tìm DropDownList trong dòng đó và chọn đúng giá trị
                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlTrangThai");
                if (ddl != null)
                {
                    ddl.SelectedValue = trangThai;

                    // Tô màu cho đẹp (Tùy chọn)
                    if (trangThai == "Mới") ddl.CssClass += " border-danger text-danger";
                    if (trangThai == "Hoàn tất") ddl.CssClass += " border-success text-success";
                }
            }
        }

        // Sự kiện khi Admin thay đổi DropDownList
        protected void ddlTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl.NamingContainer;

            // Lấy ID đơn hàng từ HiddenField
            HiddenField hdf = (HiddenField)row.FindControl("hdfMaDonHang");
            int maDonHang = Convert.ToInt32(hdf.Value);
            string trangThaiMoi = ddl.SelectedValue;

            // Cập nhật vào Database
            UpdateTrangThai(maDonHang, trangThaiMoi);
        }

        private void UpdateTrangThai(int maDonHang, string trangThai)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = "UPDATE DonHang SET TrangThaiDonHang = @TrangThai WHERE MaDonHang = @MaDH";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@TrangThai", trangThai);
                cmd.Parameters.AddWithValue("@MaDH", maDonHang);
                cmd.ExecuteNonQuery();
            }
        }
    }
}