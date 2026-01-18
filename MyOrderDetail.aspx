<%@ Page Title="Chi tiết đơn hàng" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="MyOrderDetail.aspx.cs" Inherits="WebDoChoi.MyOrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <a href="MyOrders.aspx" class="text-decoration-none text-secondary mb-3 d-inline-block">
            <i class="fa fa-arrow-left"></i>Quay lại danh sách
        </a>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Đơn hàng #<asp:Label ID="lblMaDon" runat="server"></asp:Label></h5>
                <asp:Label ID="lblTrangThai" runat="server" CssClass="badge bg-light text-dark"></asp:Label>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p class="text-muted mb-1 fw-bold">Ngày đặt hàng</p>
                        <p class="fw-bold">
                            <asp:Label ID="lblNgayDat" runat="server"></asp:Label></p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <p class="text-muted mb-1 fw-bold">Tổng giá trị</p>
                        <h4 class="text-danger fw-bold">
                            <asp:Label ID="lblTongTien" runat="server"></asp:Label></h4>
                    </div>
                </div>
                <hr />
                <div class="row">
                    <div class="col-md-12">
                        <h6 class="fw-bold">Địa chỉ nhận hàng:</h6>
                        <p class="mb-1"><i class="fa fa-user me-2"></i>
                            <asp:Label ID="lblNguoiNhan" runat="server"></asp:Label></p>
                        <p class="mb-1"><i class="fa fa-phone me-2"></i>
                            <asp:Label ID="lblSDT" runat="server"></asp:Label></p>
                        <p class="mb-0"><i class="fa fa-map-marker-alt me-2"></i>
                            <asp:Label ID="lblDiaChi" runat="server"></asp:Label></p>
                    </div>
                </div>
            </div>
        </div>

        <h5 class="mb-3">Sản phẩm đã mua</h5>
        <asp:GridView ID="gvChiTiet" runat="server" AutoGenerateColumns="False"
            CssClass="table table-bordered align-middle bg-white">
            <Columns>
                <asp:TemplateField HeaderText="Sản phẩm">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <img src='<%# "Images/Products/" + Eval("HinhAnh") %>' width="60" class="img-thumbnail me-3" />
                            <div>
                                <p class="mb-0 fw-bold"><%# Eval("TenSanPham") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="GiaTaiThoiDiemBan" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end" />
                <asp:BoundField DataField="SoLuong" HeaderText="SL" ItemStyle-CssClass="text-center" />
                <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end fw-bold" />
            </Columns>
            <HeaderStyle CssClass="table-light" />
        </asp:GridView>
    </div>
</asp:Content>
