<%@ Page Title="Chỉnh sửa sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProductEditor.aspx.cs" Inherits="WebDoChoi.Admin.ProductEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <div class="container-fluid">
        <h2 class="mb-4 border-bottom pb-2">
            <asp:Label ID="lblTitle" runat="server" Text="THÊM SẢN PHẨM MỚI"></asp:Label>
        </h2>

        <asp:Label ID="lblError" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">Thông tin chung</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label>Tên sản phẩm (*)</label>
                            <asp:TextBox ID="txtTenSP" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenSP" ErrorMessage="Vui lòng nhập tên" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Thương hiệu</label>
                                <asp:DropDownList ID="ddlThuongHieu" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Độ tuổi</label>
                                <asp:DropDownList ID="ddlDoTuoi" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label>Mô tả chi tiết</label>
                            <asp:TextBox ID="txtMoTa" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-success text-white">Quản lý kho & Ảnh</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label>Giá bán (VNĐ) (*)</label>
                            <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="txtGia" ErrorMessage="Nhập giá bán" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label>Số lượng tồn (*)</label>
                            <asp:TextBox ID="txtTonKho" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTon" runat="server" ControlToValidate="txtTonKho" ErrorMessage="Nhập số lượng" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label>Hình ảnh sản phẩm</label>
                            <asp:FileUpload ID="fileUploadAnh" runat="server" CssClass="form-control mb-2" />

                            <div class="text-center border p-2 bg-light">
                                <asp:Image ID="imgPreview" runat="server" CssClass="img-fluid" Width="150px" Visible="false" />
                                <br />
                                <asp:Label ID="lblCurrentImg" runat="server" CssClass="small text-muted"></asp:Label>
                            </div>
                            <asp:HiddenField ID="hdfOldImage" runat="server" />
                        </div>
                        <div class="form-group mt-4">
                            <label class="fw-bold">Album ảnh phụ (Có thể chọn nhiều ảnh):</label>

                            <asp:FileUpload ID="fileUploadAlbum" runat="server" CssClass="form-control" AllowMultiple="true" />

                            <div class="d-flex flex-wrap mt-2 gap-2">
                                <asp:Repeater ID="rptAlbum" runat="server" OnItemCommand="rptAlbum_ItemCommand">
                                    <ItemTemplate>
                                        <div class="position-relative" style="display: inline-block;">
                                            <img src='<%# ResolveUrl("~/Images/Products/" + Eval("DuongDanAnh")) %>'
                                                class="img-thumbnail" style="width: 100px; height: 100px; object-fit: cover;" />
                                            <asp:LinkButton ID="btnDeleteImg" runat="server"
                                                CommandName="DeleteImage"
                                                CommandArgument='<%# Eval("MaAnh") %>'
                                                CssClass="btn btn-sm btn-danger position-absolute top-0 end-0"
                                                OnClientClick="return confirm('Bạn có chắc muốn xóa ảnh này?');">
                                                &times;
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <asp:Button ID="btnSave" runat="server" Text="LƯU SẢN PHẨM" CssClass="btn btn-primary btn-lg" OnClick="btnSave_Click" />
                    <a href="ManageProducts.aspx" class="btn btn-secondary">Hủy bỏ</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
