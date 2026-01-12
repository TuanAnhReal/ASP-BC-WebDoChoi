using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDoChoi.Models
{
    [Serializable]
    public class CartItem
    {
        public int MaSanPham { get; set; }
        public string TenSanPham { get; set; }
        public string HinhAnh { get; set; }
        public decimal GiaBan { get; set; }
        public int SoLuong { get; set; }

        public decimal ThanhTien
        {
            get { return SoLuong * GiaBan; }
        }
    }
}