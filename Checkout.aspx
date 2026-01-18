<%@ Page Title="" Language="C#" MasterPageFile="~/Custormer.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="WebDoChoi.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h2 class="text-danger border-bottom mb-4">XÁC NHẬN THANH TOÁN</h2>

        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold d-block mb-3"></asp:Label>

        <div class="row">
            <div class="col-md-6 border-end">
                <h4 class="mb-3">Thông tin giao hàng</h4>
                <div class="mb-3">
                    <label>Họ và tên (*)</label>
                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHoTen" runat="server" ControlToValidate="txtHoTen" ErrorMessage="Vui lòng nhập họ tên" CssClass="text-danger small" Display="Dynamic" />
                </div>
                <div class="mb-3">
                    <label>Số điện thoại (*)</label>
                    <asp:TextBox ID="txtSDT" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSDT" runat="server" ControlToValidate="txtSDT" ErrorMessage="Vui lòng nhập SĐT" CssClass="text-danger small" Display="Dynamic" />
                </div>
                <div class="mb-3">
                    <label>Email (*)</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Vui lòng nhập Email" CssClass="text-danger small" Display="Dynamic" />
                </div>
                <div class="mb-3">
                    <label>Địa chỉ nhận hàng (*)</label>
                    <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDiaChi" runat="server" ControlToValidate="txtDiaChi" ErrorMessage="Vui lòng nhập địa chỉ" CssClass="text-danger small" Display="Dynamic" />
                </div>
            </div>

            <div class="col-md-6 bg-light p-4 rounded">
                <h4 class="mb-3">Đơn hàng của bạn</h4>

                <asp:GridView ID="gvCheckout" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-borderless" ShowHeader="False">
                    <columns>
                        <asp:TemplateField>
                            <itemtemplate>
                                <strong><%# Eval("TenSanPham") %></strong>
                                <br />
                                <small class="text-muted">SL: <%# Eval("SoLuong") %></small>
                            </itemtemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ThanhTien" DataFormatString="{0:N0} đ" ItemStyle-CssClass="text-end fw-bold" />
                    </columns>
                </asp:GridView>

                <hr />
                <div class="d-flex justify-content-between mb-3">
                    <h5>Tổng cộng:</h5>
                    <h4 class="text-danger">
                        <asp:Label ID="lblTongTien" runat="server"></asp:Label>
                    </h4>
                </div>

                <asp:Button ID="btnOrder" runat="server" Text="XÁC NHẬN ĐẶT HÀNG"
                    CssClass="btn btn-danger w-100 py-2 fs-5" OnClick="btnOrder_Click" />
            </div>
        </div>
    </div>
</asp:Content>
