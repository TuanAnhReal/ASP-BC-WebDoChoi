<%@ Page Title="Đăng ký" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebDoChoi.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h2 class="text-center text-danger mb-4">ĐĂNG KÝ TÀI KHOẢN</h2>
        <div class="row justify-content-center">
            <div class="col-md-6 border p-4 rounded shadow-sm">
                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold"></asp:Label>

                <div class="mb-3">
                    <label>Họ và tên</label>
                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" Required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Số điện thoại</label>
                    <asp:TextBox ID="txtSDT" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Địa chỉ</label>
                    <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Mật khẩu</label>
                    <asp:TextBox ID="txtMatKhau" runat="server" CssClass="form-control" TextMode="Password" Required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Xác nhận mật khẩu</label>
                    <asp:TextBox ID="txtXacNhan" runat="server" CssClass="form-control" TextMode="Password" Required="true"></asp:TextBox>
                </div>
                
                <asp:Button ID="btnRegister" runat="server" Text="ĐĂNG KÝ NGAY" CssClass="btn btn-danger w-100" OnClick="btnRegister_Click" />
            </div>
        </div>
    </div>
</asp:Content>
