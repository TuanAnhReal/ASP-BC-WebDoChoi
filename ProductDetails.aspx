<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="WebDoChoi.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .product-image-container {
            width: 100%;
            height: 500px;
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-bottom: 15px;
        }

        #imgMain {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .thumb-img {
            width: 80px;   
            height: 80px;   
            object-fit: cover; 
            border: 2px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            margin: 0 5px;
        }

        .thumb-img:hover {
            border-color: #ed1c24;
            transform: scale(1.05); 
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-6">
                <div class="main-image mb-3 text-center border p-2">
                    <asp:Image ID="imgMain" runat="server" CssClass="img-fluid" ClientIDMode="Static" Style="max-height: 400px; object-fit: contain;" />
                </div>

                <div class="d-flex justify-content-center" style="gap: 10px;">
                    <asp:Repeater ID="rptAlbum" runat="server">
                        <ItemTemplate>
                            <img src='<%# "Images/Products/" + Eval("DuongDanAnh") %>' 
                                 class="img-thumbnail" 
                                 style="width: 80px; height: 80px; object-fit: cover; cursor: pointer; border: 2px solid #ddd;"
                                 onmouseover="this.style.borderColor='red'" 
                                 onmouseout="this.style.borderColor='#ddd'"
                                 onclick="doiAnh(this.src)" />
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="col-md-6">
                <h2 id="lblTenSP" runat="server" class="text-danger fw-bold"></h2>
                <div class="mb-3">
                    <span class="badge bg-warning text-dark">Thương hiệu: <span id="lblThuongHieu" runat="server"></span></span>
                    <span class="badge bg-info text-dark">Độ tuổi: <span id="lblDoTuoi" runat="server"></span></span>
                </div>
                
                <h1 class="text-primary fw-bold display-5" id="lblGia" runat="server"></h1>
                
                <div class="my-4">
                    <asp:Button ID="btnAddToCart" runat="server" Text="THÊM VÀO GIỎ HÀNG" 
                    CssClass="btn btn-danger mt-3" OnClick="btnAddToCart_Click" />
                </div>

                <hr />
                <h5 class="fw-bold">Mô tả sản phẩm:</h5>
                <div id="divMoTa" runat="server" class="text-secondary"></div>
            </div>
        </div>
    </div>

    <script>
        function doiAnh(srcAnhNho) {
            // Lấy thẻ ảnh lớn
            var anhLon = document.getElementById('imgMain');
            // Gán đường dẫn ảnh nhỏ vào ảnh lớn
            anhLon.src = srcAnhNho;
        }
    </script>
</asp:Content>