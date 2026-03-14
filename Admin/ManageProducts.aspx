<%@ Page Title="Quản lý sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="WebDoChoi.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* CSS làm đẹp thanh phân trang */
        .pagination-container { display: flex; justify-content: center; padding: 15px 0; }
        .pagination-container table td { padding: 0 5px; }
        .pagination-container span { padding: 6px 14px; background: #0d6efd; color: white; border-radius: 4px; font-weight: bold; }
        .pagination-container a { padding: 6px 14px; text-decoration: none; color: #0d6efd; border: 1px solid #dee2e6; border-radius: 4px; transition: 0.2s; }
        .pagination-container a:hover { background: #e9ecef; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <div class="mb-4">
            <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ SẢN PHẨM</h2>
            <asp:Label ID="lblThongBao" runat="server"></asp:Label>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 bg-light p-3 rounded shadow-sm">
            <a href="ProductEditor.aspx" class="btn btn-success fw-bold">
                <i class="fa fa-plus me-1"></i>Thêm sản phẩm mới
            </a>
            
            <div class="input-group" style="max-width: 400px;">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Nhập tên hoặc mã sản phẩm..."></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvSanPham" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-bordered table-hover align-middle bg-white mb-0"
                    DataKeyNames="MaSanPham"
                    AllowPaging="True" PageSize="10"
                    OnPageIndexChanging="gvSanPham_PageIndexChanging"
                    OnRowDeleting="gvSanPham_RowDeleting"
                    EmptyDataText="Chưa có sản phẩm nào trong hệ thống.">

                    <Columns>
                        <%-- Cột 1: Ảnh đại diện --%>
                        <asp:TemplateField HeaderText="ẢNH">
                            <ItemTemplate>
                                <img src='<%# ResolveUrl("~/Images/Products/" + Eval("HinhAnh")) %>' width="60" height="60" class="img-thumbnail" style="object-fit: cover;" />
                            </ItemTemplate>
                            <ItemStyle Width="80px" HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <%-- Cột 2: Tên & Thương hiệu --%>
                        <asp:TemplateField HeaderText="TÊN SẢN PHẨM VÀ THƯƠNG HIỆU">
                            <ItemTemplate>
                                <div class="fw-bold text-primary"><%# Eval("TenSanPham") %></div>
                                <small class="text-muted"><%# Eval("TenThuongHieu") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Cột 3: Giá bán thấp nhất --%>
                        <asp:BoundField DataField="GiaBan" HeaderText="GIÁ BÁN" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end fw-bold text-danger" HeaderStyle-Width="150px" />

                        <%-- Cột 4: Tổng tồn kho --%>
                        <asp:BoundField DataField="TongTon" HeaderText="TỒN KHO" ItemStyle-CssClass="text-center fw-bold" HeaderStyle-Width="120px" />

                        <%-- Cột 5: Chức năng --%>
                        <asp:TemplateField HeaderText="THAO TÁC" ItemStyle-CssClass="text-center" HeaderStyle-Width="120px">
                            <ItemTemplate>
                                <a href='ProductEditor.aspx?id=<%# Eval("MaSanPham") %>' class="btn btn-sm btn-info text-white me-1" title="Sửa">
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
                    
                    <PagerStyle CssClass="pagination-container" />
                    <HeaderStyle CssClass="table-light text-center fw-bold text-uppercase" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>