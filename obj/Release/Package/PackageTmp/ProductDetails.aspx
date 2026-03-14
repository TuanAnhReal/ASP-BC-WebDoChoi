<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="WebDoChoi.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="MyStyle/ProductDetails.css" rel="stylesheet" />
    <%-- Đảm bảo bạn đã có FontAwesome trong MasterPage để hiện icon ngôi sao --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-5">
        <%-- PHẦN TRÊN: ẢNH VÀ THÔNG TIN (Giữ nguyên) --%>
        <div class="row gx-5">
            <%-- CỘT TRÁI: ẢNH --%>
            <div class="col-lg-7 mb-4">
                <div class="main-image-stage shadow-sm">
                    <asp:Image ID="imgMain" runat="server" ClientIDMode="Static" />
                </div>
                <div class="thumb-wrapper">
                    <div class="slider-btn prev" onclick="scrollThumb(-100)"><i class="fa fa-chevron-left"></i></div>
                    <div class="thumbnail-scroll-area" id="thumbContainer">
                        <div class="thumb-item active" onclick="changeImage(document.getElementById('imgMain').src, this)">
                             <asp:Image ID="imgThumbMain" runat="server" /> 
                        </div>
                        <asp:Repeater ID="rptAlbum" runat="server">
                            <ItemTemplate>
                                <div class="thumb-item" onclick="changeImage('<%# "Images/Products/" + Eval("DuongDanAnh") %>', this)">
                                    <img src='<%# "Images/Products/" + Eval("DuongDanAnh") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="slider-btn next" onclick="scrollThumb(100)"><i class="fa fa-chevron-right"></i></div>
                </div>
            </div>

            <%-- CỘT PHẢI: THÔNG TIN --%>
            <div class="col-lg-5">
                <h2 class="fw-bold mb-3" style="font-size: 1.8rem; line-height: 1.4;"><asp:Label ID="lblTenSP" runat="server"></asp:Label></h2>
                <div class="d-flex align-items-center mb-4 text-muted border-bottom pb-3">
                    <div class="me-4"><i class="fa fa-tag me-1"></i> Thương hiệu: <asp:Label ID="lblThuongHieu" runat="server" CssClass="fw-bold text-dark text-uppercase"></asp:Label></div>
                    <div><i class="fa fa-barcode me-1"></i> Mã SP: <asp:Label ID="lblMaSP" runat="server"></asp:Label></div>
                </div>
                <div class="mb-4">
                    <p class="text-muted mb-1">Giá bán:</p>
                    <asp:Label ID="lblGia" runat="server" CssClass="price-tag"></asp:Label>
                </div>
                <div class="mb-4">
                    <asp:Label ID="lblTinhTrang" runat="server" CssClass="stock-status badge fs-6 px-3 py-2"></asp:Label>
                </div>
                <div class="card bg-light border-0 mb-4 rounded-3">
                    <div class="card-body">
                        <p class="fw-bold mb-2">Chọn số lượng:</p>
                        <div class="d-flex align-items-center">
                            <div class="input-group me-3" style="width: 140px;">
                                <button class="btn btn-outline-secondary bg-white" type="button" onclick="adjustQty(-1)">-</button>
                                <asp:TextBox ID="txtSoLuong" runat="server" TextMode="Number" Text="1" min="1" max="99" CssClass="form-control text-center border-secondary" ClientIDMode="Static"></asp:TextBox>
                                <button class="btn btn-outline-secondary bg-white" type="button" onclick="adjustQty(1)">+</button>
                            </div>
                        </div>
                        <div class="mt-3">
                             <asp:Button ID="btnAddToCart" runat="server" Text="THÊM VÀO GIỎ HÀNG" 
                                CssClass="btn btn-danger btn-lg w-100 fw-bold shadow-sm py-3" OnClick="btnAddToCart_Click" />
                        </div>
                    </div>
                </div>
                <div class="mt-4">
                     <h6 class="fw-bold text-uppercase border-bottom pb-2 mb-2">Mô tả ngắn</h6>
                     <p class="text-secondary" style="text-align: justify;">
                         <div id="lblMoTaNgan" runat="server" class="product-content"></div>
                     </p>
                </div>
            </div>
        </div>

        <%-- MÔ TẢ CHI TIẾT --%>
        <div class="row mt-5">
            <div class="col-12">
                <div class="bg-white p-4 rounded shadow-sm border">
                    <h4 class="fw-bold text-danger border-bottom pb-3 mb-4"><i class="fa fa-file-text-o me-2"></i> CHI TIẾT SẢN PHẨM</h4>
                    <div id="divMoTaChiTiet" runat="server" class="product-content"></div>
                </div>
            </div>
        </div>

        <%-- PHẦN ĐÁNH GIÁ --%>
        <div class="row mt-5">
            <div class="col-12">
                <div class="bg-white p-4 rounded shadow-sm border">
                    <h4 class="border-bottom pb-2 mb-4 text-uppercase fw-bold text-danger"><i class="fa fa-star me-2"></i> Đánh giá sản phẩm</h4>
        
                    <div class="row">
                        <%-- Danh sách Review --%>
                        <div class="col-md-7 mb-4 mb-md-0">
                            <asp:Repeater ID="rptDanhGia" runat="server">
                                <ItemTemplate>
                                    <div class="card mb-3 shadow-sm border-0">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between">
                                                <h6 class="fw-bold text-primary"><i class="fa fa-user-circle me-1"></i> <%# Eval("HoTen") %></h6>
                                                <small class="text-muted"><%# Eval("NgayGui", "{0:dd/MM/yyyy}") %></small>
                                            </div>
                                            <div class="mb-2">
                                                <%-- Hàm HienThiSao xử lý backend --%>
                                                <%# HienThiSao(Convert.ToInt32(Eval("SoSao"))) %>
                                            </div>
                                            <p class="mb-0 text-dark"><%# Eval("NoiDung") %></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="lblEmpty" runat="server" Visible='<%# rptDanhGia.Items.Count == 0 %>' 
                                        Text="Chưa có đánh giá nào. Hãy là người đầu tiên!" CssClass="text-muted fst-italic"></asp:Label>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>

                        <%-- Form Viết Review --%>
                        <div class="col-md-5">
                            <div class="card bg-light border-0">
                                <div class="card-body">
                                    <h5 class="fw-bold mb-3">Viết đánh giá của bạn</h5>
                                    <asp:Label ID="lblLoiDanhGia" runat="server" CssClass="d-block mb-2 fw-bold"></asp:Label>

                                    <div class="mb-3">
                                        <label class="fw-bold">Chọn mức độ hài lòng:</label>
                                        <asp:RadioButtonList ID="rblSoSao" runat="server" RepeatDirection="Horizontal" CssClass="mt-1 w-100">
                                            <asp:ListItem Value="5" Selected="True"> 5 Sao</asp:ListItem>
                                            <asp:ListItem Value="4"> 4 Sao</asp:ListItem>
                                            <asp:ListItem Value="3"> 3 Sao</asp:ListItem>
                                            <asp:ListItem Value="2"> 2 Sao</asp:ListItem>
                                            <asp:ListItem Value="1"> 1 Sao</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>

                                    <div class="mb-3">
                                        <label class="fw-bold">Nội dung đánh giá:</label>
                                        <asp:TextBox ID="txtNoiDungDanhGia" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Chia sẻ cảm nhận của bạn..."></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvNoiDung" runat="server" ControlToValidate="txtNoiDungDanhGia" 
                                            ErrorMessage="Vui lòng nhập nội dung" CssClass="text-danger small" Display="Dynamic" ValidationGroup="ReviewGroup" />
                                    </div>

                                    <asp:Button ID="btnGuiDanhGia" runat="server" Text="Gửi đánh giá" CssClass="btn btn-primary w-100" 
                                        OnClick="btnGuiDanhGia_Click" ValidationGroup="ReviewGroup" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- SẢN PHẨM LIÊN QUAN --%>
        <div class="mt-5">
            <h4 class="text-uppercase fw-bold border-bottom pb-2 mb-4">Sản phẩm cùng thương hiệu</h4>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-4">
                <asp:Repeater ID="rptLienQuan" runat="server">
                    <ItemTemplate>
                        <div class="col">
                            <div class="card h-100 border-0 product-related-card shadow-sm">
                                <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>'>
                                    <img src='<%# "Images/Products/" + Eval("HinhAnh") %>' class="card-img-top p-3" alt='<%# Eval("TenSanPham") %>' style="height: 180px; object-fit: contain;">
                                </a>
                                <div class="card-body text-center">
                                    <h6 class="card-title text-truncate">
                                        <a href='ProductDetails.aspx?id=<%# Eval("MaSanPham") %>' class="text-decoration-none text-dark"><%# Eval("TenSanPham") %></a>
                                    </h6>
                                    <p class="text-danger fw-bold"><%# Eval("GiaBan", "{0:N0} đ") %></p>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <%-- JAVASCRIPT --%>
    <script>
        function changeImage(src, element) {
            var mainImg = document.getElementById('imgMain');
            if (mainImg.src === src) return;
            mainImg.classList.add('fading');
            setTimeout(function () {
                mainImg.src = src;
                mainImg.classList.remove('fading');
            }, 200);
            var thumbs = document.querySelectorAll('.thumb-item');
            thumbs.forEach(t => t.classList.remove('active'));
            if (element) element.classList.add('active');
        }
        function scrollThumb(distance) {
            var container = document.getElementById('thumbContainer');
            container.scrollBy({ left: distance, behavior: 'smooth' });
        }
        function adjustQty(delta) {
            var txt = document.getElementById('txtSoLuong');
            var current = parseInt(txt.value) || 1;
            var max = parseInt(txt.getAttribute('max')) || 99;
            var newVal = current + delta;
            if (newVal >= 1 && newVal <= max) txt.value = newVal;
        }
    </script>
</asp:Content>