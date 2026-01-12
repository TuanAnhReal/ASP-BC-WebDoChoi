<%@ Page Title="Đăng nhập" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebDoChoi.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h2 class="text-center text-primary mb-4">ĐĂNG NHẬP</h2>
        <div class="row justify-content-center">
            <div class="col-md-5 border p-4 rounded shadow-sm">
                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold"></asp:Label>

                <div class="mb-3">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label>Mật khẩu</label>
                    <asp:TextBox ID="txtMatKhau" runat="server" CssClass="form-control" TextMode="Password" Required="true"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="ĐĂNG NHẬP" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />
                
                <div class="mt-3 text-center">
                    Chưa có tài khoản? <a href="Register.aspx">Đăng ký ngay</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
