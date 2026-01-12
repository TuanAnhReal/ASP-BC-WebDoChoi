<%@ Page Title="Giỏ hàng của bạn" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="WebDoChoi.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <h2 class="text-danger border-bottom mb-4">GIỎ HÀNG CỦA BẠN</h2>

        <div id="divEmpty" runat="server" visible="false" class="alert alert-warning text-center">
            <h4>Giỏ hàng của bạn đang trống!</h4>
            <a href="Default.aspx" class="btn btn-primary mt-2">Quay lại mua sắm</a>
        </div>

        <asp:Panel ID="pnlCart" runat="server">
            
            <asp:GridView ID="gvGioHang" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-bordered table-hover align-middle"
                DataKeyNames="MaSanPham"
                OnRowDeleting="gvGioHang_RowDeleting" 
                ShowFooter="True">
                
                <Columns>
                    <%-- Cột Ảnh --%>
                    <asp:TemplateField HeaderText="Ảnh">
                        <ItemTemplate>
                            <img src='<%# "Images/Products/" + Eval("HinhAnh") %>' width="80" class="img-thumbnail" />
                        </ItemTemplate>
                        <ItemStyle Width="100px" />
                    </asp:TemplateField>

                    <%-- Cột Tên --%>
                    <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />

                    <%-- Cột Giá --%>
                    <asp:BoundField DataField="GiaBan" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end" />

                    <%-- Cột Số lượng (Textbox cho phép sửa) --%>
                    <asp:TemplateField HeaderText="Số lượng">
                        <ItemTemplate>
                            <asp:TextBox ID="txtSoLuong" runat="server" Text='<%# Eval("SoLuong") %>' 
                                TextMode="Number" Min="1" CssClass="form-control text-center" Width="80px">
                            </asp:TextBox>
                        </ItemTemplate>
                        <ItemStyle Width="120px" />
                    </asp:TemplateField>

                    <%-- Cột Thành tiền --%>
                    <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="fw-bold text-danger text-end" />

                    <%-- Cột Chức năng (Xóa) --%>
                    <asp:TemplateField HeaderText="Xóa" ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                CssClass="btn btn-outline-danger btn-sm"
                                OnClientClick="return confirm('Bạn có chắc muốn xóa sản phẩm này không?');">
                                <i class="fa fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="table-light text-center" />
            </asp:GridView>

            <div class="row mt-3 align-items-center">
                <div class="col-md-6">
                    <a href="Default.aspx" class="btn btn-secondary me-2"><i class="fa fa-arrow-left"></i> Tiếp tục mua</a>
                    <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật giỏ hàng" 
                        CssClass="btn btn-warning text-white" OnClick="btnUpdate_Click" />
                </div>
                <div class="col-md-6 text-end">
                    <h4>Tổng cộng: <asp:Label ID="lblTongTien" runat="server" Text="0 đ" CssClass="text-danger fw-bold"></asp:Label></h4>
                    <asp:Button ID="btnThanhToan" runat="server" Text="TIẾN HÀNH THANH TOÁN" CssClass="btn btn-danger btn-lg mt-2" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
