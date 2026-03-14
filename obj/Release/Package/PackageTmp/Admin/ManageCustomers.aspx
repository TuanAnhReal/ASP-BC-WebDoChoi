<%@ Page Title="Quản lý khách hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCustomers.aspx.cs" Inherits="WebDoChoi.Admin.ManageCustomers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">DANH SÁCH KHÁCH HÀNG</h2>

        <asp:Label ID="lblThongBao" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

        <div class="row g-3 mb-4">
            <div class="col-md-5">
                <div class="input-group">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Nhập tên hoặc số điện thoại..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="btnSearch_Click">
                        <i class="fa fa-search"></i>Tìm kiếm
                   
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btn-secondary" OnClick="btnReset_Click" ToolTip="Làm mới">
                        <i class="fa fa-refresh"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvKhachHang" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-hover align-middle mb-0"
                    DataKeyNames="MaKhachHang" OnRowCommand="gvKhachHang_RowCommand"
                    EmptyDataText="Không tìm thấy khách hàng nào.">
                    <columns>
                        <asp:BoundField DataField="MaKhachHang" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="text-center fw-bold" />

                        <asp:TemplateField HeaderText="Thông tin cá nhân">
                            <itemtemplate>
                                <div class="fw-bold"><%# Eval("HoTen") %></div>
                                <small class="text-muted"><i class="fa fa-envelope me-1"></i><%# Eval("Email") %></small>
                            </itemtemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="SoDienThoai" HeaderText="Số điện thoại" />
                        <asp:BoundField DataField="DiaChi" HeaderText="Địa chỉ" />

                        <%-- Trạng thái: Hiển thị Badge màu sắc --%>
                        <asp:TemplateField HeaderText="Trạng thái" ItemStyle-CssClass="text-center">
                            <itemtemplate>
                                <%# Convert.ToBoolean(Eval("TrangThai")) == true 
                                    ? "<span class='badge bg-success'>Đang hoạt động</span>" 
                                    : "<span class='badge bg-danger'>Đã khóa</span>" %>
                            </itemtemplate>
                        </asp:TemplateField>

                        <%-- Chức năng --%>
                        <asp:TemplateField HeaderText="Thao tác" ItemStyle-CssClass="text-center">
                            <itemtemplate>
                                <%-- Link xem lịch sử mua hàng (Trỏ về trang ManageOrders với tham số uid) --%>
                                <a href='ManageOrders.aspx?uid=<%# Eval("MaKhachHang") %>' class="btn btn-sm btn-info text-white me-1" title="Xem lịch sử mua hàng">
                                    <i class="fa fa-history"></i>
                                </a>

                                <%-- Nút Khóa / Mở khóa --%>
                                <%-- Logic: Nếu đang True (1) thì hiện nút Khóa. Nếu False (0) thì hiện nút Mở --%>
                                <asp:LinkButton ID="btnLock" runat="server" CommandName="KhoaTaiKhoan"
                                    CommandArgument='<%# Eval("MaKhachHang") %>'
                                    Visible='<%# Convert.ToBoolean(Eval("TrangThai")) == true %>'
                                    CssClass="btn btn-sm btn-warning" ToolTip="Khóa tài khoản này"
                                    OnClientClick="return confirm('Bạn có chắc muốn KHÓA tài khoản này?');">
                                    <i class="fa fa-lock"></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnUnlock" runat="server" CommandName="MoKhoaTaiKhoan"
                                    CommandArgument='<%# Eval("MaKhachHang") %>'
                                    Visible='<%# Convert.ToBoolean(Eval("TrangThai")) == false %>'
                                    CssClass="btn btn-sm btn-success" ToolTip="Mở khóa tài khoản"
                                    OnClientClick="return confirm('Bạn muốn MỞ KHÓA tài khoản này?');">
                                    <i class="fa fa-unlock"></i>
                                </asp:LinkButton>
                            </itemtemplate>
                        </asp:TemplateField>
                    </columns>
                    <headerstyle cssclass="table-light fw-bold text-uppercase small" />
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
