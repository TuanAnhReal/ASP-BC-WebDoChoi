<%@ Page Title="Quản lý sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="WebDoChoi.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <div class="mb-4">
            <h2 class="mb-4">QUẢN LÝ SẢN PHẨM</h2>
            <asp:Label ID="lblThongBao" runat="server" CssClass=""></asp:Label>
        </div>

        <div class="d-flex justify-content-between mb-3">
            <a href="ProductEditor.aspx" class="btn btn-success">
                <i class="fa fa-plus"></i>Thêm sản phẩm mới
            </a>
        </div>

        <asp:GridView ID="gvSanPham" runat="server" AutoGenerateColumns="False"
            CssClass="table table-bordered table-hover align-middle bg-white"
            DataKeyNames="MaSanPham"
            OnRowDeleting="gvSanPham_RowDeleting"
            EmptyDataText="Chưa có sản phẩm nào trong hệ thống.">

            <Columns>
                <%-- Cột 1: Ảnh đại diện --%>
                <asp:TemplateField HeaderText="Hình ảnh">
                    <ItemTemplate>
                        <img src='<%# ResolveUrl("~/Images/Products/" + Eval("HinhAnh")) %>' width="60" height="60" class="img-thumbnail" style="object-fit: cover;" />
                    </ItemTemplate>
                    <ItemStyle Width="80px" HorizontalAlign="Center" />
                </asp:TemplateField>

                <%-- Cột 2: Tên & Thương hiệu --%>
                <asp:TemplateField HeaderText="Thông tin sản phẩm">
                    <ItemTemplate>
                        <div class="fw-bold text-primary"><%# Eval("TenSanPham") %></div>
                        <small class="text-muted">Thương hiệu: <%# Eval("TenThuongHieu") %></small>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Cột 3: Giá bán thấp nhất --%>
                <asp:BoundField DataField="GiaBan" HeaderText="Giá bán (từ)" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end fw-bold" />

                <%-- Cột 4: Tổng tồn kho --%>
                <asp:BoundField DataField="TongTon" HeaderText="Tồn kho" ItemStyle-CssClass="text-center" />

                <%-- Cột 5: Chức năng --%>
                <asp:TemplateField HeaderText="Thao tác" ItemStyle-CssClass="text-center" ItemStyle-Width="150px">
                    <ItemTemplate>
                        <a href='ProductEditor.aspx?id=<%# Eval("MaSanPham") %>' class="btn btn-sm btn-primary me-1" title="Sửa">
                            <i class="fa fa-edit"></i>
                        </a>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                            CssClass="btn btn-sm btn-danger"
                            OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này? Hành động này không thể hoàn tác!');" title="Xóa">
                            <i class="fa fa-trash"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="table-light text-center" />
        </asp:GridView>
    </div>
</asp:Content>
