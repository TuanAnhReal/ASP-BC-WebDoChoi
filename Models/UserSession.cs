using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDoChoi.Models
{
    [Serializable]
    public class UserSession
    {
        public int MaKhachHang { get; set; }
        public string HoTen { get; set; }
        public string Email { get; set; }
    }
}