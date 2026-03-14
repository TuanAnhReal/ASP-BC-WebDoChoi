<%@ Page Title="Quản lý Nhóm sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProductGroups.aspx.cs" Inherits="WebDoChoi.Admin.ManageProductGroups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ NHÓM SẢN PHẨM</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fa fa-layer-group me-2"></i>Thêm / Sửa Nhóm</h5>
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblThongBao" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

                        <asp:HiddenField ID="hdfMaNhom" runat="server" />

                        <div class="mb-3">
                            <label class="form-label">Tên nhóm sản phẩm (*)</label>
                            <asp:TextBox ID="txtTenNhom" runat="server" CssClass="form-control" placeholder="Ví dụ: Đồ chơi lắp ráp..."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenNhom"
                                ErrorMessage="Vui lòng nhập tên nhóm!" CssClass="text-danger small" Display="Dynamic" ValidationGroup="GroupForm" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <asp:TextBox ID="txtMoTa" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Mô tả ngắn gọn về nhóm này..."></asp:TextBox>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnLuu" runat="server" Text="Lưu dữ liệu" CssClass="btn btn-success"
                                OnClick="btnLuu_Click" ValidationGroup="GroupForm" />

                            <asp:Button ID="btnHuy" runat="server" Text="Hủy bỏ / Làm mới" CssClass="btn btn-secondary"
                                OnClick="btnHuy_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 text-primary">Danh sách nhóm hiện có</h5>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvNhom" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-hover mb-0 align-middle"
                            OnRowCommand="gvNhom_RowCommand" EmptyDataText="Chưa có nhóm sản phẩm nào.">
                            <columns>
                                <%-- Cột 1: Mã --%>
                                <asp:BoundField DataField="MaNhom" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="text-center fw-bold" />

                                <%-- Cột 2: Tên --%>
                                <asp:BoundField DataField="TenNhom" HeaderText="Tên Nhóm" ItemStyle-CssClass="fw-bold" />

                                <%-- Cột 3: Mô tả (Dùng hàm Helper cắt chuỗi) --%>
                                <asp:TemplateField HeaderText="Mô tả">
                                    <itemtemplate>
                                        <span class="text-muted"><%# CatChuoiMoTa(Eval("MoTa")) %></span>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <%-- Cột 4: Chức năng --%>
                                <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="150px" ItemStyle-CssClass="text-center">
                                    <itemtemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Sua"
                                            CommandArgument='<%# Eval("MaNhom") %>'
                                            CssClass="btn btn-sm btn-primary me-2" ToolTip="Sửa">
                                            <i class="fa fa-edit"></i>
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Xoa"
                                            CommandArgument='<%# Eval("MaNhom") %>'
                                            CssClass="btn btn-sm btn-danger" ToolTip="Xóa"
                                            OnClientClick="return confirm('Bạn có chắc chắn muốn xóa nhóm này không?');">
                                            <i class="fa fa-trash"></i>
                                        </asp:LinkButton>
                                    </itemtemplate>
                                </asp:TemplateField>
                            </columns>
                            <headerstyle cssclass="table-light text-uppercase small fw-bold" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
