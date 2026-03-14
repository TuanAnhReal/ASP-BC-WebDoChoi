<%@ Page Title="Quản lý Thương hiệu" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageBrands.aspx.cs" Inherits="WebDoChoi.Admin.ManageBrands" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ THƯƠNG HIỆU</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fa fa-pen-nib me-2"></i>Thêm / Sửa Thương hiệu</h5>
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblThongBao" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

                        <asp:HiddenField ID="hdfMaThuongHieu" runat="server" />

                        <div class="mb-3">
                            <label class="form-label">Tên thương hiệu (*)</label>
                            <asp:TextBox ID="txtTenThuongHieu" runat="server" CssClass="form-control" placeholder="Nhập tên thương hiệu..."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenThuongHieu"
                                ErrorMessage="Không được để trống!" CssClass="text-danger small" Display="Dynamic" ValidationGroup="BrandGroup" />
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnLuu" runat="server" Text="Lưu dữ liệu" CssClass="btn btn-success"
                                OnClick="btnLuu_Click" ValidationGroup="BrandGroup" />

                            <asp:Button ID="btnHuy" runat="server" Text="Hủy bỏ / Làm mới" CssClass="btn btn-secondary"
                                OnClick="btnHuy_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 text-primary">Danh sách thương hiệu hiện có</h5>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvThuongHieu" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-hover mb-0 align-middle"
                            OnRowCommand="gvThuongHieu_RowCommand" EmptyDataText="Chưa có dữ liệu.">
                            <Columns>
                                <%-- Cột 1: Mã --%>
                                <asp:BoundField DataField="MaThuongHieu" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="text-center" />

                                <%-- Cột 2: Tên --%>
                                <asp:BoundField DataField="TenThuongHieu" HeaderText="Tên Thương Hiệu" />

                                <%-- Cột 3: Chức năng --%>
                                <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="150px" ItemStyle-CssClass="text-center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Sua"
                                            CommandArgument='<%# Eval("MaThuongHieu") %>'
                                            CssClass="btn btn-sm btn-primary me-2" ToolTip="Sửa">
                                            <i class="fa fa-edit"></i>
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Xoa"
                                            CommandArgument='<%# Eval("MaThuongHieu") %>'
                                            CssClass="btn btn-sm btn-danger" ToolTip="Xóa"
                                            OnClientClick="return confirm('Bạn có chắc chắn muốn xóa thương hiệu này không?');">
                                            <i class="fa fa-trash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="table-light text-uppercase small fw-bold" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
