using System;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace WebDoChoi.Models
{
    public class MailHelper
    {
        // Cấu hình Email gửi đi (Của Shop)
        private static readonly string _fromEmail = "thegioidochoi200402@gmail.com";
        private static readonly string _password = "wlxv dnrh pert uncj";

        public static void SendMail(string toEmail, string subject, string body)
        {
            try
            {
                // Tạo đối tượng MailMessage
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(_fromEmail, "Thế Giới Đồ Chơi"); // Tên hiển thị
                mail.To.Add(toEmail);
                mail.Subject = subject;
                mail.Body = body;
                mail.IsBodyHtml = true; // Cho phép gửi nội dung HTML
                mail.BodyEncoding = Encoding.UTF8;

                // Cấu hình SMTP Client
                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true; // Bắt buộc với Gmail
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(_fromEmail, _password);

                // Gửi mail
                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // Ghi log lỗi nếu cần thiết (Tránh làm sập web nếu gửi mail lỗi)
                System.Diagnostics.Debug.WriteLine("Gửi mail thất bại: " + ex.Message);
            }
        }
    }
}