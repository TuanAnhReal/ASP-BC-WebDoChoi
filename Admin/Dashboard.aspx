<%@ Page Title="Bảng điều khiển" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebDoChoi.Admin.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 text-secondary">TỔNG QUAN HỆ THỐNG</h2>

        <div class="row g-3 mb-4">
            
            <div class="col-md-3">
                <div class="card text-white bg-success h-100 shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-uppercase mb-0">Tổng Doanh Thu</h6>
                            <h3 class="fw-bold mt-2 mb-0">
                                <asp:Label ID="lblDoanhThu" runat="server" Text="0 đ"></asp:Label>
                            </h3>
                            <small class="text-white-50">Đơn hàng hoàn tất</small>
                        </div>
                        <div class="fs-1 text-white-50"><i class="fa fa-money-bill-wave"></i></div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-white bg-warning h-100 shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-uppercase mb-0">Đơn Hàng Mới</h6>
                            <h3 class="fw-bold mt-2 mb-0">
                                <asp:Label ID="lblDonMoi" runat="server" Text="0"></asp:Label>
                            </h3>
                            <small class="text-dark-50">Cần xử lý ngay</small>
                        </div>
                        <div class="fs-1 text-white-50"><i class="fa fa-shopping-cart"></i></div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-white bg-primary h-100 shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-uppercase mb-0">Sản Phẩm</h6>
                            <h3 class="fw-bold mt-2 mb-0">
                                <asp:Label ID="lblSanPham" runat="server" Text="0"></asp:Label>
                            </h3>
                            <small class="text-white-50">Đang kinh doanh</small>
                        </div>
                        <div class="fs-1 text-white-50"><i class="fa fa-box-open"></i></div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-white bg-info h-100 shadow-sm">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title text-uppercase mb-0">Khách Hàng</h6>
                            <h3 class="fw-bold mt-2 mb-0">
                                <asp:Label ID="lblKhachHang" runat="server" Text="0"></asp:Label>
                            </h3>
                            <small class="text-white-50">Thành viên đăng ký</small>
                        </div>
                        <div class="fs-1 text-white-50"><i class="fa fa-users"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow mb-4">
            <div class="card-header py-3 bg-white border-bottom-0">
                <h5 class="m-0 fw-bold text-primary"><i class="fa fa-list-alt me-2"></i>5 Đơn hàng mới nhất</h5>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gvDonMoi" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover table-striped mb-0 align-middle" GridLines="None" ShowHeader="true">
                    <Columns>
                        <asp:BoundField DataField="MaDonHang" HeaderText="Mã ĐH" ItemStyle-CssClass="fw-bold text-center" HeaderStyle-CssClass="text-center" />
                        
                        <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
                        
                        <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        
                        <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="fw-bold text-danger text-end" HeaderStyle-CssClass="text-end" />
                        
                        <asp:TemplateField HeaderText="Trạng thái" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <span class='badge <%# GetBadgeClass(Eval("TrangThaiDonHang")) %>'>
                                    <%# Eval("TrangThaiDonHang") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <a href='OrderDetail.aspx?id=<%# Eval("MaDonHang") %>' class="btn btn-sm btn-outline-primary">Xem</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="table-light text-uppercase small fw-bold" />
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
