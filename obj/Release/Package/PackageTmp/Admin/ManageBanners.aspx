<%@ Page Title="Quản lý Banner" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageBanners.aspx.cs" Inherits="WebDoChoi.Admin.ManageBanners" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">

    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">QUẢN LÝ BANNER QUẢNG CÁO</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fa fa-image me-2"></i>Thêm / Sửa Banner</h5>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="hdfMaQC" runat="server" />
                        <asp:HiddenField ID="hdfAnhCu" runat="server" />

                        <div class="mb-3">
                            <label>Tiêu đề (Alt text)</label>
                            <asp:TextBox ID="txtTieuDe" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label>Hình ảnh (*)</label>
                            <asp:FileUpload ID="fileUploadAnh" runat="server" CssClass="form-control mb-2" />
                            <asp:Image ID="imgPreview" runat="server" CssClass="img-thumbnail" Width="100%" Visible="false" />
                        </div>

                        <div class="mb-3">
                            <label>Liên kết (Link khi click)</label>
                            <asp:TextBox ID="txtLienKet" runat="server" CssClass="form-control" placeholder="VD: Default.aspx?id=1"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-6 mb-3">
                                <label>Thứ tự</label>
                                <asp:TextBox ID="txtThuTu" runat="server" CssClass="form-control" TextMode="Number" Text="1"></asp:TextBox>
                            </div>
                            <div class="col-6 mb-3 d-flex align-items-end">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkHienThi" runat="server" Checked="true" CssClass="form-check-input" />
                                    <label class="form-check-label">Hiển thị ngay</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnLuu" runat="server" Text="Lưu Banner" CssClass="btn btn-success" OnClick="btnLuu_Click" />
                            <asp:Button ID="btnHuy" runat="server" Text="Hủy bỏ" CssClass="btn btn-secondary" OnClick="btnHuy_Click" />
                        </div>
                    </div>
                    <asp:Label ID="lblThongBao" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <asp:GridView ID="gvBanner" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-bordered table-hover align-middle mb-0"
                            OnRowCommand="gvBanner_RowCommand" EmptyDataText="Chưa có banner nào.">
                            <columns>
                                <asp:TemplateField HeaderText="Ảnh" ItemStyle-Width="120px">
                                    <itemtemplate>
                                        <asp:Image ID="imgBanner" runat="server" 
                                                     ImageUrl='<%# "~/Images/Banners/" + Eval("HinhAnh") %>' 
                                                     Width="150px" CssClass="img-thumbnail" />
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="TieuDe" HeaderText="Tiêu đề" />
                                <asp:BoundField DataField="ThuTu" HeaderText="TT" ItemStyle-Width="50px" ItemStyle-CssClass="text-center" />

                                <asp:TemplateField HeaderText="Trạng thái" ItemStyle-Width="100px" ItemStyle-CssClass="text-center">
                                    <itemtemplate>
                                        <%# Convert.ToBoolean(Eval("HienThi")) ? "<span class='badge bg-success'>Hiện</span>" : "<span class='badge bg-secondary'>Ẩn</span>" %>
                                    </itemtemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="120px" ItemStyle-CssClass="text-center">
                                    <itemtemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Sua" CommandArgument='<%# Eval("MaQC") %>' CssClass="btn btn-sm btn-primary"><i class="fa fa-edit"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Xoa" CommandArgument='<%# Eval("MaQC") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Xóa banner này?');"><i class="fa fa-trash"></i></asp:LinkButton>
                                    </itemtemplate>
                                </asp:TemplateField>
                            </columns>
                            <headerstyle cssclass="table-light fw-bold" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
