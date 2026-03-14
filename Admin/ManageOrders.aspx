<%@ Page Title="Quản lý đơn hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="WebDoChoi.Admin.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../MyStyle/Admin.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ ĐƠN HÀNG</h2>

        <div class="card shadow-sm mb-4">
            <div class="card-body bg-light">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="fa fa-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Mã đơn, Mã KH hoặc Tên KH..."></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold">Trạng thái đơn hàng</label>
                        <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select">
                            <asp:ListItem Text="-- Tất cả trạng thái --" Value="" />
                            <asp:ListItem Text="Mới" Value="Mới" />
                            <asp:ListItem Text="Đang giao" Value="Đang giao" />
                            <asp:ListItem Text="Hoàn tất" Value="Hoàn tất" />
                            <asp:ListItem Text="Đã hủy" Value="Đã hủy" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold">Sản phẩm có trong đơn</label>
                        <asp:DropDownList ID="ddlFilterProduct" runat="server" CssClass="form-select">
                            <asp:ListItem Text="-- Tất cả sản phẩm --" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnSearch" runat="server" Text="Lọc dữ liệu" CssClass="btn btn-primary w-100" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0 bg-white"
                    AllowPaging="True" PageSize="10" 
                    OnPageIndexChanging="gvDonHang_PageIndexChanging"
                    OnRowDataBound="gvDonHang_RowDataBound"
                    DataKeyNames="MaDonHang"
                    EmptyDataText="Không tìm thấy đơn hàng nào phù hợp với điều kiện lọc.">
                    
                    <Columns>
                        <asp:BoundField DataField="MaDonHang" HeaderText="Mã ĐH" ItemStyle-CssClass="fw-bold" HeaderStyle-Width="90" />
                        <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
                        <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-danger fw-bold" />
                        
                        <%-- DropDownList thay đổi trạng thái --%>
                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlTrangThai" runat="server" CssClass="form-select form-select-sm" 
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlTrangThai_SelectedIndexChanged">
                                    <asp:ListItem Value="Mới">Đơn hàng mới</asp:ListItem>
                                    <asp:ListItem Value="Đang giao">Đang giao hàng</asp:ListItem>
                                    <asp:ListItem Value="Hoàn tất">Hoàn tất</asp:ListItem>
                                    <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
                                </asp:DropDownList>
                                <asp:HiddenField ID="hdfMaDonHang" runat="server" Value='<%# Eval("MaDonHang") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Nút xem chi tiết --%>
                        <asp:TemplateField HeaderText="Thao tác" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <a href='OrderDetail.aspx?id=<%# Eval("MaDonHang") %>' class="btn btn-sm btn-info text-white"><i class="fa fa-eye"></i> Xem</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <PagerStyle CssClass="p-3 text-center pagination" />
                    <HeaderStyle CssClass="table-light fw-bold text-uppercase small" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>