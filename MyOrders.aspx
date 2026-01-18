<%@ Page Title="Đơn hàng của tôi" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="WebDoChoi.MyOrders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h3 class="mb-4 border-bottom pb-2 text-danger">LỊCH SỬ ĐƠN HÀNG</h3>

        <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" 
            CssClass="table table-hover align-middle shadow-sm bg-white rounded" 
            GridLines="None" EmptyDataText="Bạn chưa có đơn hàng nào."
            OnRowDataBound="gvDonHang_RowDataBound">
            <Columns>
                <%-- Mã đơn hàng --%>
                <asp:BoundField DataField="MaDonHang" HeaderText="Mã đơn" ItemStyle-CssClass="fw-bold" />

                <%-- Ngày đặt --%>
                <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                <%-- Tổng tiền --%>
                <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-danger fw-bold" />

                <%-- Trạng thái (Sẽ xử lý màu trong Code-behind) --%>
                <asp:TemplateField HeaderText="Trạng thái">
                    <ItemTemplate>
                        <asp:Label ID="lblTrangThai" runat="server" Text='<%# Eval("TrangThaiDonHang") %>' CssClass="badge rounded-pill"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Nút xem chi tiết --%>
                <asp:TemplateField ItemStyle-CssClass="text-end">
                    <ItemTemplate>
                        <a href='MyOrderDetail.aspx?id=<%# Eval("MaDonHang") %>' class="btn btn-outline-primary btn-sm">
                            <i class="fa fa-eye"></i> Xem chi tiết
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-light fw-bold" />
        </asp:GridView>
    </div>
</asp:Content>
