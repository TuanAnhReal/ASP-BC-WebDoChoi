<%@ Page Title="Quản lý đơn hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="WebDoChoi.Admin.ManageOrders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <h2 class="mb-4">QUẢN LÝ ĐƠN HÀNG</h2>
    
    <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" 
        CssClass="table table-striped table-bordered"
        DataKeyNames="MaDonHang" 
        OnRowDataBound="gvDonHang_RowDataBound">
        <Columns>
            <asp:BoundField DataField="MaDonHang" HeaderText="Mã ĐH" />
            <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
            <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
            <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" />
            
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
            <asp:TemplateField HeaderText="Thao tác">
                <ItemTemplate>
                    <a href='OrderDetail.aspx?id=<%# Eval("MaDonHang") %>' class="btn btn-primary btn-sm">Xem chi tiết</a>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
