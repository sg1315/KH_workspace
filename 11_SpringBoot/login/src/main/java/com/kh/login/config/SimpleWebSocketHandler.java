package com.kh.login.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.login.auth.JwtTokenProvider;
import com.kh.login.dto.chat.ChatMessageDto;
import com.kh.login.service.ChatService;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class SimpleWebSocketHandler extends TextWebSocketHandler {

    //WebSocket에 접속한 사용자 세션들을 채팅방 단위로 관리하기 위한 구조
    private final Map<Long, Set<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    //수신한 채팅 메시지를 데이터베이스에 저장하는 비즈니스 로직을 담당
    private final ChatService chatService;
    //JSON 문자열을을 직렬화/역직렬화 하기위한 Jackson객체
    private final ObjectMapper objectMapper = new ObjectMapper();
    // WebSocket 연결 시 보낸 JWT 토큰을 검증하기위한 객체
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public SimpleWebSocketHandler(ChatService chatService, JwtTokenProvider jwtTokenProvider) {
        this.chatService = chatService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    //클라이언트가 WebSocket 연결을 시도하면 호출되는 메서드
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // 쿼리 파라미터에서 roomId, token 추출
        String query = session.getUri().getQuery();
        Long roomId = null;
        String token = null;
        if (query != null) {
            String[] params = query.split("&");
            for (String param : params) {
                if (param.startsWith("roomId=")) {
                    roomId = Long.parseLong(param.substring(7));
                } else if (param.startsWith("token=")) {
                    token = param.substring(6);
                }
            }
        }
        if (roomId == null || token == null) {
            session.close();
            return;
        }
        // JWT 검증
        try {
            jwtTokenProvider.parseClaims(token);
            System.out.println("WebSocket JWT 인증 성공");
        } catch (Exception e) {
            System.out.println("WebSocket JWT 인증 실패: " + e.getMessage());
            session.close();
            return;
        }

        // 세션에 roomId 저장 (나중에 연결 종료 시 필요)
        session.getAttributes().put("roomId", roomId);

        // roomId에 해당하는 세션 Set에 추가 (없으면 새로 생성)
        //computeIfAbsent() 해당 키에 값이 있으면 그 값을 반환하고 없다면 새로운 값을 만들어서 넣어준다.
        roomSessions.computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet()).add(session);
        System.out.println("Connected : " + session.getId() + " to room " + roomId);
    }


    //클라이언트가 보낸 메시지를 서버가 수신했을 때 호출
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

        //JSON → DTO 변환
        String payload = message.getPayload();
        System.out.println("received message : " + payload);
        ChatMessageDto chatMessageDto = objectMapper.readValue(payload, ChatMessageDto.class);
        //메시지 DB 저장
        chatService.saveMessage(chatMessageDto);

        //해당 채팅방(roomId)에만 브로드캐스트
        Long roomId = chatMessageDto.getRoomId();
        Set<WebSocketSession> targetSessions = roomSessions.get(roomId);
        if (targetSessions != null) {
            for (WebSocketSession s : targetSessions) {
                if (s.isOpen()) {
                    s.sendMessage(new TextMessage(payload));
                }
            }
        }
    }

    //WebSocket 클라이언트가 연결을 끊었을 때 자동으로 호출
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        //사용자의 WebSocket 세션을 roomSessions에서 제거
        Long roomId = (Long) session.getAttributes().get("roomId");
        if (roomId != null) {
            Set<WebSocketSession> sessions = roomSessions.get(roomId);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    roomSessions.remove(roomId);
                }
            }
        }
        System.out.println("disconnected!!");
    }


}