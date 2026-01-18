<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="WebDoChoi.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/MyStyle/ProductDetails.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-5">
        <%-- BỐ CỤC 6:4 (Sử dụng col-lg-7 và col-lg-5) --%>
        <div class="row gx-5">
            
            <%-- PHẦN 1: ẢNH SẢN PHẨM (Chiếm 7 phần ~ 60%) --%>
            <div class="col-lg-7 mb-4">
                
                <%-- Khung ảnh lớn --%>
                <div class="main-image-stage shadow-sm">
                    <asp:Image ID="imgMain" runat="server" ClientIDMode="Static" />
                </div>

                <%-- Carousel Thumbnail --%>
                <div class="thumb-wrapper">
                    <div class="slider-btn prev" onclick="scrollThumb(-100)"><i class="fa fa-chevron-left"></i></div>
                    
                    <div class="thumbnail-scroll-area" id="thumbContainer">
                        <%-- Thêm lại ảnh chính vào đầu danh sách thumb để user quay lại được --%>
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

            <%-- PHẦN 2: THÔNG TIN SẢN PHẨM (Chiếm 5 phần ~ 40%) --%>
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

                <div class="description-box mt-4">
                     <h6 class="fw-bold text-uppercase border-bottom pb-2 mb-2">Mô tả ngắn</h6>
                     <p class="text-secondary" style="text-align: justify;">
                         <asp:Label ID="lblMoTaNgan" runat="server"></asp:Label>
                     </p>
                </div>
            </div>
        </div>

        <%-- PHẦN MÔ TẢ CHI TIẾT & SẢN PHẨM LIÊN QUAN --%>
        <div class="row mt-5">
            <div class="col-12">
                <div class="bg-white p-4 rounded shadow-sm border">
                    <h4 class="fw-bold text-danger border-bottom pb-3 mb-4"><i class="fa fa-file-text-o me-2"></i> CHI TIẾT SẢN PHẨM</h4>
                    <div id="divMoTaChiTiet" runat="server" class="product-content"></div>
                </div>
            </div>
        </div>

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

    <%-- JAVASCRIPT XỬ LÝ ẢNH & SLIDER --%>
    <script>
        // 1. Hàm đổi ảnh lớn với hiệu ứng Fade
        function changeImage(src, element) {
            var mainImg = document.getElementById('imgMain');

            // Nếu đang click vào ảnh hiện tại thì không làm gì
            if (mainImg.src === src) return;

            // Thêm class để làm mờ ảnh
            mainImg.classList.add('fading');

            // Đợi 200ms (cho khớp với CSS transition) rồi đổi src và hiện lại
            setTimeout(function () {
                mainImg.src = src;
                mainImg.classList.remove('fading');
            }, 200);

            // Xử lý active class cho thumbnail
            var thumbs = document.querySelectorAll('.thumb-item');
            thumbs.forEach(t => t.classList.remove('active'));
            if (element) {
                element.classList.add('active');
            }
        }

        // 2. Hàm Scroll Thumbnail (Carousel)
        function scrollThumb(distance) {
            var container = document.getElementById('thumbContainer');
            container.scrollBy({ left: distance, behavior: 'smooth' });
        }

        // 3. Hàm tăng giảm số lượng (+ -)
        function adjustQty(delta) {
            var txt = document.getElementById('txtSoLuong');
            var currentVal = parseInt(txt.value) || 1;
            var newVal = currentVal + delta;

            // Kiểm tra min/max (giả sử max 99 hoặc lấy từ attribute max)
            var max = parseInt(txt.getAttribute('max')) || 99;
            if (newVal >= 1 && newVal <= max) {
                txt.value = newVal;
            }
        }
    </script>
</asp:Content>