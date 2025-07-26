package com.kh.login.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@RequiredArgsConstructor
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    private final SimpleWebSocketHandler simpleWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        //WebSocket 요청을 처리할 핸들러(simpleWebSocketHandler)를 등록
        //CORS 허용 도메인 설정
        //registry.addHandler(핸들러객체, 요청경로)
        // /connect url로 websocket연결 요청이 들어오면, 핸들러 클래스가 처리
        registry.addHandler(simpleWebSocketHandler, "/connect")
                .setAllowedOrigins("http://localhost:3000");
    }
}
/*
@EnableWebSocket: WebSocket 관련 설정을 활성화하는 어노테이션, 내부적으로 WebSocketConfigurer를 구현한 클래스를 자동으로 인식하여 WebSocket 핸들러를 등록하게 만듭니다.
*/
