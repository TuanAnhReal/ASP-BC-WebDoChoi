<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="WebDoChoi.OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5 text-center">
        <div class="text-success mb-4">
            <i class="fa fa-check-circle fa-5x"></i>
        </div>
        <h2 class="text-success">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p class="lead">Cảm ơn bạn đã mua sắm tại Thế giới đồ chơi.</p>
        <p>Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng.</p>
        <a href="Default.aspx" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
    </div>
</asp:Content>
