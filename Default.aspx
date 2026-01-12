<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebDoChoi.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="mb-4 text-danger border-bottom pb-2">SẢN PHẨM MỚI NHẤT</h3>
    <div class="row row-cols-1 row-cols-md-4 g-4">
        <asp:Repeater ID="rptSanPham" runat="server">
            <ItemTemplate>
                <div class="col">
                    <div class="card h-100 shadow-sm border-0">
                        <a  href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>'>
                        <img src='<%# "Images/Products/" + Eval("DuongDanAnh") %>' 
                            class="card-img-top p-3" alt='<%# Eval("TenSanPham") %>'>
                        </a>
                        <div class="card-body text-center">
                            <h6 class="card-title text-truncate"><%# Eval("TenSanPham") %></h6>
                            <p class="card-text text-danger fw-bold">
                                <%# string.Format("{0:N0} đ", Eval("GiaBan")) %>
                            </p>
                            <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>' class="btn btn-outline-danger btn-sm">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
