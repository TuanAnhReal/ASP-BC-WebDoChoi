<%@ Page Title="Thông tin tài khoản" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="WebDoChoi.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h3 class="mb-4 text-center fw-bold">QUẢN LÝ HỒ SƠ</h3>

                <ul class="nav nav-tabs mb-4" id="profileTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active fw-bold" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button">
                            <i class="fa fa-user me-2"></i>Thông tin chung
                       
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link fw-bold" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button">
                            <i class="fa fa-key me-2"></i>Đổi mật khẩu
                       
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="profileTabContent">

                    <div class="tab-pane fade show active" id="info">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">
                                <asp:Label ID="lblMsgInfo" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

                                <div class="mb-3">
                                    <label class="form-label text-muted">Email đăng nhập</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light" Enabled="false"></asp:TextBox>
                                    <small class="text-muted fst-italic">* Email không thể thay đổi</small>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên (*)</label>
                                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtHoTen" ErrorMessage="Vui lòng nhập họ tên" CssClass="text-danger small" Display="Dynamic" ValidationGroup="InfoGroup" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại (*)</label>
                                    <asp:TextBox ID="txtSDT" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtSDT" ErrorMessage="Vui lòng nhập SĐT" CssClass="text-danger small" Display="Dynamic" ValidationGroup="InfoGroup" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                </div>

                                <div class="text-end">
                                    <asp:Button ID="btnUpdateInfo" runat="server" Text="Cập nhật thông tin"
                                        CssClass="btn btn-primary px-4" OnClick="btnUpdateInfo_Click" ValidationGroup="InfoGroup" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="password">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">
                                <asp:Label ID="lblMsgPass" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu hiện tại</label>
                                    <asp:TextBox ID="txtOldPass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvOldPass" runat="server" ControlToValidate="txtOldPass" ErrorMessage="Nhập mật khẩu cũ" CssClass="text-danger small" Display="Dynamic" ValidationGroup="PassGroup" />
                                </div>
                                <hr />
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNewPass" runat="server" ControlToValidate="txtNewPass" ErrorMessage="Nhập mật khẩu mới" CssClass="text-danger small" Display="Dynamic" ValidationGroup="PassGroup" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nhập lại mật khẩu mới</label>
                                    <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirmPass" ControlToCompare="txtNewPass"
                                        ErrorMessage="Mật khẩu xác nhận không khớp" CssClass="text-danger small" Display="Dynamic" ValidationGroup="PassGroup" />
                                </div>

                                <div class="text-end">
                                    <asp:Button ID="btnChangePass" runat="server" Text="Lưu mật khẩu mới"
                                        CssClass="btn btn-danger px-4" OnClick="btnChangePass_Click" ValidationGroup="PassGroup" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
