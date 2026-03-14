using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading.Tasks;
using WebDoChoi.Models;

namespace WebDoChoi.Admin
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        // Sử dụng đúng chuỗi kết nối của bạn
        string strConn = ConfigurationManager.ConnectionStrings["DB_WEB_DO_CHOI_Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDanhSachSanPham(); // Nạp danh sách vào DropDownList Sản phẩm
                LoadDonHang();         // Tải dữ liệu lần đầu
            }
        }

        private void LoadDanhSachSanPham()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT MaSanPham, TenSanPham FROM SanPham ORDER BY TenSanPham";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlFilterProduct.DataSource = dt;
                ddlFilterProduct.DataTextField = "TenSanPham";
                ddlFilterProduct.DataValueField = "MaSanPham";
                ddlFilterProduct.DataBind();

                // Thêm tùy chọn mặc định lên đầu
                ddlFilterProduct.Items.Insert(0, new ListItem("-- Tất cả sản phẩm --", "0"));
            }
        }

        private void LoadDonHang()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Câu lệnh nền tảng (Base SQL)
                string sql = @"
                    SELECT d.MaDonHang, d.NgayDat, d.TongTien, d.TrangThaiDonHang, k.HoTen, k.MaKhachHang 
                    FROM DonHang d 
                    JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang 
                    WHERE 1=1 ";

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                // A. XỬ LÝ ĐIỀU KIỆN TÌM KIẾM TỪ KHÓA
                string searchText = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(searchText))
                {
                    if (int.TryParse(searchText, out int searchId))
                    {
                        sql += " AND (d.MaDonHang = @SearchID OR k.MaKhachHang = @SearchID OR k.HoTen LIKE @SearchName) ";
                        cmd.Parameters.AddWithValue("@SearchID", searchId);
                        cmd.Parameters.AddWithValue("@SearchName", "%" + searchText + "%");
                    }
                    else
                    {
                        sql += " AND (k.HoTen LIKE @SearchName) ";
                        cmd.Parameters.AddWithValue("@SearchName", "%" + searchText + "%");
                    }
                }

                // B. XỬ LÝ ĐIỀU KIỆN LỌC TRẠNG THÁI
                if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue))
                {
                    sql += " AND d.TrangThaiDonHang = @Status ";
                    cmd.Parameters.AddWithValue("@Status", ddlFilterStatus.SelectedValue);
                }

                // C. XỬ LÝ ĐIỀU KIỆN LỌC THEO SẢN PHẨM
                if (ddlFilterProduct.SelectedValue != "0")
                {
                    sql += @" AND EXISTS (
                                SELECT 1 FROM ChiTietDonHang ct 
                                JOIN BienTheSanPham bt ON ct.MaBienThe = bt.MaBienThe 
                                WHERE ct.MaDonHang = d.MaDonHang 
                                AND bt.MaSanPham = @ProductID
                              ) ";
                    cmd.Parameters.AddWithValue("@ProductID", ddlFilterProduct.SelectedValue);
                }

                // Sắp xếp đơn mới nhất lên đầu
                sql += " ORDER BY d.NgayDat DESC";
                cmd.CommandText = sql;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDonHang.DataSource = dt;
                gvDonHang.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvDonHang.PageIndex = 0; // Đưa về trang 1 mỗi khi lọc mới
            LoadDonHang();
        }

        protected void gvDonHang_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDonHang.PageIndex = e.NewPageIndex; // Chuyển sang trang mới
            LoadDonHang(); // Load lại dữ liệu giữ nguyên các điều kiện lọc
        }


        // =========================================================================
        // PHẦN 2: TÍNH NĂNG CẬP NHẬT TRẠNG THÁI & GỬI MAIL (CODE CŨ GIỮ NGUYÊN)
        // =========================================================================

        protected void gvDonHang_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string trangThai = DataBinder.Eval(e.Row.DataItem, "TrangThaiDonHang").ToString();
                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlTrangThai");
                if (ddl != null)
                {
                    ddl.SelectedValue = trangThai;

                    // Tô màu trạng thái cho Admin dễ nhìn
                    if (trangThai == "Mới") ddl.CssClass += " text-danger fw-bold";
                    if (trangThai == "Đang giao") ddl.CssClass += " text-warning fw-bold";
                    if (trangThai == "Hoàn tất") ddl.CssClass += " text-success fw-bold";
                }
            }
        }

        protected void ddlTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl.NamingContainer;

            HiddenField hdf = (HiddenField)row.FindControl("hdfMaDonHang");
            int maDonHang = Convert.ToInt32(hdf.Value);
            string trangThaiMoi = ddl.SelectedValue;

            // 1. Cập nhật Database
            UpdateTrangThai(maDonHang, trangThaiMoi);

            // 2. Gửi Email thông báo
            if (trangThaiMoi == "Đang giao" || trangThaiMoi == "Hoàn tất" || trangThaiMoi == "Đã hủy")
            {
                CustomerInfo info = GetCustomerInfo(maDonHang);

                if (info != null && !string.IsNullOrEmpty(info.Email))
                {
                    Task.Run(() =>
                    {
                        GuiEmailBackground(info, maDonHang, trangThaiMoi);
                    });
                }
            }

            // Tải lại GridView để cập nhật màu sắc mới cho Dropdown
            LoadDonHang();
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

        // Class tạm để chứa thông tin khách hàng
        private class CustomerInfo
        {
            public string Email { get; set; }
            public string HoTen { get; set; }
            public decimal TongTien { get; set; }
        }

        private CustomerInfo GetCustomerInfo(int maDonHang)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                string sql = @"SELECT k.Email, k.HoTen, d.TongTien 
                               FROM DonHang d 
                               JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang 
                               WHERE d.MaDonHang = @ID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", maDonHang);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    return new CustomerInfo
                    {
                        Email = dr["Email"].ToString(),
                        HoTen = dr["HoTen"].ToString(),
                        TongTien = Convert.ToDecimal(dr["TongTien"])
                    };
                }
                return null;
            }
        }

        private void GuiEmailBackground(CustomerInfo info, int maDonHang, string trangThai)
        {
            try
            {
                string color = "#333";
                string message = "";

                switch (trangThai)
                {
                    case "Đang giao":
                        color = "#ffc107";
                        message = "Đơn hàng của bạn đã được bàn giao cho đơn vị vận chuyển. Vui lòng chú ý điện thoại.";
                        break;
                    case "Hoàn tất":
                        color = "#198754";
                        message = "Đơn hàng đã giao thành công. Cảm ơn bạn đã mua sắm tại TheGioiDoChoi!";
                        break;
                    case "Đã hủy":
                        color = "#dc3545";
                        message = "Rất tiếc, đơn hàng của bạn đã bị hủy. Vui lòng liên hệ shop nếu có nhầm lẫn.";
                        break;
                }

                string subject = $"Cập nhật trạng thái đơn hàng #{maDonHang} - {trangThai.ToUpper()}";

                string body = $@"
                    <div style='font-family: Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e1e1e1;'>
                        <div style='background-color: #ED1C24; padding: 15px; text-align: center;'>
                            <h2 style='color: white; margin: 0;'>THÔNG BÁO ĐƠN HÀNG</h2>
                        </div>
                        <div style='padding: 20px;'>
                            <p>Xin chào <strong>{info.HoTen}</strong>,</p>
                            <p>Trạng thái đơn hàng <strong>#{maDonHang}</strong> của bạn vừa được cập nhật:</p>
                            
                            <div style='text-align: center; padding: 20px; background-color: #f8f9fa; margin: 20px 0;'>
                                <span style='font-size: 24px; font-weight: bold; color: {color}; text-transform: uppercase;'>
                                    {trangThai}
                                </span>
                                <p style='margin-top: 10px; color: #666;'>{message}</p>
                            </div>

                            <table style='width: 100%; border-collapse: collapse;'>
                                <tr>
                                    <td style='padding: 10px; border-bottom: 1px solid #eee;'><strong>Tổng giá trị:</strong></td>
                                    <td style='padding: 10px; border-bottom: 1px solid #eee; text-align: right; color: #ED1C24; font-weight: bold;'>
                                        {string.Format("{0:N0} đ", info.TongTien)}
                                    </td>
                                </tr>
                            </table>

                            <p style='margin-top: 30px; font-size: 13px; color: #999;'>
                                Đây là email tự động, vui lòng không trả lời email này.<br/>
                                Hotline hỗ trợ: 1900 8168
                            </p>
                        </div>
                    </div>";

                MailHelper.SendMail(info.Email, subject, body);
            }
            catch
            {
                // Bỏ qua nếu có lỗi gửi mail
            }
        }
    }
}