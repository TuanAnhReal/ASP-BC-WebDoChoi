<%@ Page Title="Trang chủ" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebDoChoi.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row">
            <div class="col-md-3">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-danger text-white fw-bold">
                        <i class="fa fa-filter"></i> BỘ LỌC TÌM KIẾM
                    </div>
                    <div class="card-body">
                        <h6 class="fw-bold mt-2">Thương hiệu</h6>
                        <div style="max-height: 200px; overflow-y: auto;">
                            <asp:CheckBoxList ID="cblThuongHieu" runat="server" CssClass="form-check" 
                                DataTextField="TenThuongHieu" DataValueField="MaThuongHieu">
                            </asp:CheckBoxList>
                        </div>
                        <hr />

                        <h6 class="fw-bold">Mức giá</h6>
                        <asp:RadioButtonList ID="rblGia" runat="server" CssClass="form-check">
                            <asp:ListItem Value="0" Selected="True">Tất cả</asp:ListItem>
                            <asp:ListItem Value="1">Dưới 500.000đ</asp:ListItem>
                            <asp:ListItem Value="2">Từ 500.000đ - 1.000.000đ</asp:ListItem>
                            <asp:ListItem Value="3">Trên 1.000.000đ</asp:ListItem>
                        </asp:RadioButtonList>
                        
                        <hr />
                        <asp:Button ID="btnFilter" runat="server" Text="ÁP DỤNG LỌC" 
                            CssClass="btn btn-danger w-100" OnClick="btnFilter_Click" />
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 bg-light rounded">
                    <div>
                        <span class="fw-bold">Kết quả: </span>
                        <asp:Label ID="lblKetQuaTimKiem" runat="server" Text="0 sản phẩm" class="text-danger fw-bold"></asp:Label>
                    </div>
                    <div class="d-flex align-items-center">
                        <label class="me-2 text-nowrap">Sắp xếp:</label>
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select form-select-sm" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                            <asp:ListItem Value="new">Mới nhất</asp:ListItem>
                            <asp:ListItem Value="price_asc">Giá tăng dần</asp:ListItem>
                            <asp:ListItem Value="price_desc">Giá giảm dần</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <asp:ListView ID="lvSanPham" runat="server">
                    <LayoutTemplate>
                        <div class="row row-cols-1 row-cols-md-3 g-4">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <div class="col">
                            <div class="card h-100 shadow-sm border-0 product-card">
                                <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>' class="text-decoration-none">
                                    <div class="position-relative overflow-hidden text-center bg-white">
                                        <img src='<%# "Images/Products/" + Eval("HinhAnh") %>' class="card-img-top p-3" 
                                             alt='<%# Eval("TenSanPham") %>' style="height: 220px; object-fit: contain;">
                                    </div>
                                </a>
                                <div class="card-body">
                                    <h6 class="card-title text-truncate">
                                        <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>' class="text-decoration-none text-dark hover-danger">
                                            <%# Eval("TenSanPham") %>
                                        </a>
                                    </h6>
                                    <p class="card-text text-danger fw-bold fs-5 mb-1">
                                        <%# Eval("GiaBan", "{0:N0} đ") %>
                                    </p>
                                    
                                    <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>' class="btn btn-outline-danger btn-sm w-100 mt-2">
                                        <i class="fa fa-shopping-cart"></i> Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <div class="alert alert-warning text-center w-100">
                            Không tìm thấy sản phẩm nào phù hợp với tiêu chí lọc.
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
                
                </div>
        </div>
    </div>
</asp:Content>
