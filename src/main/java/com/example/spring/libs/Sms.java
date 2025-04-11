package com.example.spring.libs;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

public class Sms {
    
    // 문자 보내기
    public void sendSmsViaCoolsms(String smsMessage, String phone) {
        // 문자 발송을 위한 Nurigo SDK 초기화
        String apiKey = "";
        String secretKey = "";
        String apiUrl = "https://api.coolsms.co.kr";
        DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize(apiKey, secretKey, apiUrl);
        // Message 패키지가 중복될 경우 net.nurigo.sdk.message.model.Message로 치환하여 주세요
        Message message = new Message();
        message.setFrom("전화번호");
        message.setTo(phone);
        message.setText(smsMessage);

        try {
            // send 메소드로 ArrayList<Message> 객체를 넣어도 동작합니다!
            messageService.send(message);
        } catch (NurigoMessageNotReceivedException exception) {
            // 발송에 실패한 메시지 목록을 확인할 수 있습니다!
            System.out.println(exception.getFailedMessageList());
            System.out.println(exception.getMessage());
        } catch (Exception exception) {
            System.out.println(exception.getMessage());
        }
    }
}
