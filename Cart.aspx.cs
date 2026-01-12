using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDoChoi.Models;

namespace WebDoChoi
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();

            }
        }

        // Hàm nạp dữ liệu chung, xử lý ẩn hiện giao diện
        private void BindGrid()
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem>;

            // Kiểm tra nếu giỏ hàng tồn tại và có sản phẩm
            if (cart != null && cart.Count > 0)
            {
                pnlCart.Visible = true;       // Hiện bảng giỏ hàng
                divEmpty.Visible = false;     // Ẩn thông báo trống

                gvGioHang.DataSource = cart;
                gvGioHang.DataBind();

                // Tính lại tổng tiền
                decimal tongTien = cart.Sum(x => x.ThanhTien);
                lblTongTien.Text = string.Format("{0:N0} đ", tongTien);
            }
            else
            {
                pnlCart.Visible = false;      // Ẩn bảng giỏ hàng
                divEmpty.Visible = true;      // Hiện thông báo trống
            }
        }

        // 1. XỬ LÝ SỰ KIỆN XÓA SẢN PHẨM
        protected void gvGioHang_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Lấy ID sản phẩm từ DataKeys dựa vào chỉ số dòng (RowIndex)
            int maSP = Convert.ToInt32(gvGioHang.DataKeys[e.RowIndex].Value);

            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart != null)
            {
                // Tìm sản phẩm trong List và xóa
                CartItem itemToRemove = cart.Find(x => x.MaSanPham == maSP);
                if (itemToRemove != null)
                {
                    cart.Remove(itemToRemove);
                }

                // Cập nhật lại Session và nạp lại GridView
                Session["Cart"] = cart;
                BindGrid();
            }
        }

        // 2. XỬ LÝ SỰ KIỆN CẬP NHẬT GIỎ HÀNG
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart != null)
            {
                // Duyệt qua từng dòng của GridView
                foreach (GridViewRow row in gvGioHang.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        // 1. Lấy ID sản phẩm từ DataKey của dòng đó
                        int maSP = Convert.ToInt32(gvGioHang.DataKeys[row.RowIndex].Value);

                        // 2. Tìm control TextBox số lượng trong dòng đó
                        TextBox txtSoLuong = (TextBox)row.FindControl("txtSoLuong");

                        // 3. Tìm sản phẩm tương ứng trong List Session
                        CartItem item = cart.Find(x => x.MaSanPham == maSP);

                        if (item != null && txtSoLuong != null)
                        {
                            int newQuantity;
                            // Kiểm tra parse số an toàn và số lượng > 0
                            if (int.TryParse(txtSoLuong.Text, out newQuantity) && newQuantity > 0)
                            {
                                item.SoLuong = newQuantity;
                            }
                        }
                    }
                }

                // Lưu lại Session sau khi đã cập nhật hết các dòng
                Session["Cart"] = cart;

                // Nạp lại giao diện để hiển thị Thành tiền và Tổng tiền mới
                BindGrid();
            }

        }
    }
}