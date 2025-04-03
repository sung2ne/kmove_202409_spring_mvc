package com.example.spring.libs;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Email {

    // 네이버 메일 보내기
    public void sendEmailViaNaver(String mailSubject, String mailContent, String mailTo) {
        // 이메일 전송 설정
        String mailFrom = "sung3ne@naver.com";  // 발신자 이메일

        // 이메일 전송 properties 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.naver.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // 보내는 사람 계정 설정
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("아이디", "비밀번호");
            }
        });

        try {
            // 메일 내용 작성
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(mailFrom));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailTo));
            msg.setSubject(mailSubject);
            // msg.setText(mailContent);
            msg.setContent(mailContent, "text/html; charset=utf-8");

            // 메일 전송
            Transport transport = session.getTransport("smtp");
            transport.connect();
            Transport.send(msg);
        } catch (AddressException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // 구글 메일 보내기
    public void sendEmailViaGmail() {

    }
    
}
