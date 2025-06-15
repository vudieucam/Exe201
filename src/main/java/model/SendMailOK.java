package model;

import java.util.Date;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class SendMailOK {

    public static void send(String smtpServer, String to, String from, String psw,
                            String subject, String body) throws Exception {

        Properties props = System.getProperties();
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", smtpServer);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", smtpServer);

        Authenticator pa = new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, psw);
            }
        };

        Session session = Session.getInstance(props, pa);
        session.setDebug(true); // Debug để xem log gửi mail

        MimeMessage msg = new MimeMessage(session);

        // ✅ Set người gửi với tên hiển thị có dấu (nếu muốn)
        msg.setFrom(new InternetAddress(from, "PetTech", "UTF-8"));

        // ✅ Đảm bảo tiêu đề đúng tiếng Việt
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject, "UTF-8");

        // ✅ Nội dung HTML UTF-8
        msg.setContent(body, "text/html; charset=UTF-8");

        msg.setHeader("X-Mailer", "LOTONtechEmail");
        msg.setSentDate(new Date());
        msg.saveChanges();

        Transport.send(msg);
        System.out.println("Message sent OK.");
    }
}
