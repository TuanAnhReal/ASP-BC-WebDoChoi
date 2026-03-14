<%@ Page Title="Quản lý Đánh giá" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageReviews.aspx.cs" Inherits="WebDoChoi.Admin.ManageReviews" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ ĐÁNH GIÁ</h2>
        
        <asp:Label ID="lblThongBao" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

        <div class="row g-2 mb-4 align-items-center bg-light p-3 rounded border">
            <div class="col-auto fw-bold">Tìm kiếm:</div>
            <div class="col-auto">
                <asp:TextBox ID="txtTuKhoa" runat="server" CssClass="form-control" placeholder="Nhập tên sản phẩm hoặc mã SP..." Width="300px"></asp:TextBox>
            </div>
            <div class="col-auto">
                <asp:Button ID="btnTim" runat="server" Text="Tìm kiếm" CssClass="btn btn-primary" OnClick="btnTim_Click" />
            </div>
            <div class="col-auto">
                <asp:Button ID="btnTatCa" runat="server" Text="Hiện tất cả" CssClass="btn btn-secondary" OnClick="btnTatCa_Click" />
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvDanhGia" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0"
                    DataKeyNames="MaDanhGia"
                    AllowPaging="True" PageSize="10"
                    OnPageIndexChanging="gvDanhGia_PageIndexChanging"
                    OnRowDeleting="gvDanhGia_RowDeleting"
                    EmptyDataText="Không tìm thấy đánh giá nào phù hợp.">
                    
                    <Columns>
                        <%-- Cột 1: Mã ĐG --%>
                        <asp:BoundField DataField="MaDanhGia" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="text-center text-muted" />
                        
                        <%-- Cột 2: Sản phẩm --%>
                        <asp:TemplateField HeaderText="Sản phẩm">
                            <ItemTemplate>
                                <span class="fw-bold text-primary"><%# Eval("TenSanPham") %></span>
                                <br />
                                <small class="text-muted">Mã SP: <%# Eval("MaSanPham") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Cột 3: Khách hàng --%>
                        <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" ItemStyle-Font-Bold="true" />

                        <%-- Cột 4: Số sao --%>
                        <asp:TemplateField HeaderText="Đánh giá" ItemStyle-Width="100px" ItemStyle-CssClass="text-warning text-center">
                            <ItemTemplate>
                                <%# Eval("SoSao") %> <i class="fa fa-star"></i>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Cột 5: Nội dung --%>
                        <asp:BoundField DataField="NoiDung" HeaderText="Nội dung" ItemStyle-Width="30%" />
                        
                        <%-- Cột 6: Ngày gửi --%>
                        <asp:BoundField DataField="NgayGui" HeaderText="Ngày gửi" DataFormatString="{0:dd/MM/yyyy HH:mm}" ItemStyle-CssClass="text-nowrap" />

                        <%-- Cột 7: Xóa --%>
                        <asp:TemplateField HeaderText="Xóa" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                    CssClass="btn btn-sm btn-danger" ToolTip="Xóa đánh giá này"
                                    OnClientClick="return confirm('Hành động này không thể hoàn tác. Bạn chắc chắn muốn xóa?');">
                                    <i class="fa fa-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <%-- Style phân trang --%>
                    <PagerStyle CssClass="p-3 text-center" />
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
