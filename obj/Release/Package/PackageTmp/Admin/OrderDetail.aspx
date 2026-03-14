<%@ Page Title="Chi tiết đơn hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OrderDetail.aspx.cs" Inherits="WebDoChoi.Admin.OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <a href="ManageOrders.aspx" class="btn btn-secondary mb-3"><i class="fa fa-arrow-left"></i>Quay lại danh sách</a>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">THÔNG TIN ĐƠN HÀNG #<asp:Label ID="lblMaDon" runat="server"></asp:Label></h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6 border-end">
                        <p><strong>Ngày đặt hàng:</strong>
                            <asp:Label ID="lblNgayDat" runat="server"></asp:Label>
                        </p>
                        <p><strong>Trạng thái:</strong>
                            <asp:Label ID="lblTrangThai" runat="server" CssClass="badge"></asp:Label>
                        </p>
                    </div>
                    <div class="col-md-6 ps-4">
                        <p><strong>Khách hàng:</strong>
                            <asp:Label ID="lblKhachHang" runat="server"></asp:Label>
                        </p>
                        <p><strong>Số điện thoại:</strong>
                            <asp:Label ID="lblSDT" runat="server"></asp:Label>
                        </p>
                        <p><strong>Địa chỉ giao:</strong>
                            <asp:Label ID="lblDiaChi" runat="server"></asp:Label>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <h5 class="mb-3 text-danger border-bottom pb-2">DANH SÁCH SẢN PHẨM</h5>

        <asp:GridView ID="gvChiTiet" runat="server" AutoGenerateColumns="False"
            CssClass="table table-bordered table-hover align-middle bg-white" ShowFooter="True">
            <columns>
                <%-- Cột 1: Ảnh sản phẩm --%>
                <asp:TemplateField HeaderText="Hình ảnh">
                    <itemtemplate>
                        <img src='<%# ResolveUrl("~/Images/Products/" + Eval("HinhAnh")) %>' width="60" height="60" class="img-thumbnail" style="object-fit: cover;" />
                    </itemtemplate>
                    <itemstyle width="80px" horizontalalign="Center" />
                </asp:TemplateField>

                <%-- Cột 2: Tên sản phẩm --%>
                <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />

                <%-- Cột 3: Giá bán (lúc mua) --%>
                <asp:BoundField DataField="GiaTaiThoiDiemBan" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end" />

                <%-- Cột 4: Số lượng --%>
                <asp:BoundField DataField="SoLuong" HeaderText="SL" ItemStyle-CssClass="text-center fw-bold" />

                <%-- Cột 5: Thành tiền --%>
                <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end fw-bold text-danger" />
            </columns>
            <footerstyle cssclass="table-light fw-bold text-end fs-5" />
        </asp:GridView>

        <div class="text-end mt-3">
            <h4>Tổng thanh toán:
                <asp:Label ID="lblTongTien" runat="server" CssClass="text-danger fw-bold"></asp:Label>
            </h4>
        </div>
    </div>
</asp:Content>
