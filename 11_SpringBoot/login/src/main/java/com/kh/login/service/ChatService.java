package com.kh.login.service;

import com.kh.login.auth.JwtTokenProvider;
import com.kh.login.domain.Member;
import com.kh.login.domain.chat.ChatMessage;
import com.kh.login.domain.chat.ChatParticipant;
import com.kh.login.domain.chat.ChatRoom;
import com.kh.login.domain.chat.ReadStatus;
import com.kh.login.dto.chat.ChatMessageDto;
import com.kh.login.dto.chat.ChatRoomResponse;
import com.kh.login.dto.chat.MyChatResponse;
import com.kh.login.repository.MemberRepository;
import com.kh.login.repository.chat.ChatMessageRepository;
import com.kh.login.repository.chat.ChatParicipantRepository;
import com.kh.login.repository.chat.ChatRoomRepository;
import com.kh.login.repository.chat.ReadStatusRepository;
import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;

@Transactional
@Service
@RequiredArgsConstructor
public class ChatService {

    private final MemberRepository memberRepository;
    private final ChatParicipantRepository chatParticipantRepository;
    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final ReadStatusRepository readStatusRepository;
    private final JwtTokenProvider jwtTokenProvider;


    //1:1채팅방 생성 또는 조회
    public Long getOrCreatePrivateRoom(Long otherMemberId) {
        //현재 로그인한 사용자와 상대방 사용자 조회
        Member member = memberRepository.findByEmail(SecurityContextHolder.getContext().getAuthentication().getName())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        Member otherMember = memberRepository.findById(otherMemberId)
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        Optional<ChatRoom> chatRoom = chatParticipantRepository.findExistingPrivateRoom(member.getId(), otherMember.getId());
        if (chatRoom.isPresent()) {
            return chatRoom.get().getId();
        }

        ChatRoom newRoom = new ChatRoom().builder()
                .isGroupChat("N")
                .name(member.getName() + "_" + otherMember.getName())
                .build();

        chatRoomRepository.save(newRoom);

        addParticipantToRoom(newRoom, member);
        addParticipantToRoom(newRoom, otherMember);

        return newRoom.getId();
    }

    //채팅방 참여자 추가
    //해당 참여자가 이미 참여중인지 확인 후 참여하지 않은 경우에만 새로운 참여자 추가
    public void addParticipantToRoom(ChatRoom chatRoom, Member member) {
        if(chatParticipantRepository.findByChatRoomAndMember(chatRoom, member).isPresent()) {
            return;
        }

        //새로운 참가자 생성
        ChatParticipant chatParticipant = ChatParticipant.builder()
                .chatRoom(chatRoom)
                .member(member)
                .build();
        chatParticipantRepository.save(chatParticipant);
    }

    /**
     * 채팅내역조회
     * 1. 채팅방 존재여부 체크
     * 2. 현재 사용자가 해당 채팅방의 참여자인지
     * 3. 채팅방의 모든 메세지를 시간순으로 조회
     * 4. 메세지정보를 DTO로 변환해서 반환
     *
     * @param roomId 조회할 채탕방 ID
     * @return 채팅 메세지 목록(발신자 이베일, 메세지 내용)
     */
    public List<ChatMessageDto> getChatHistory(Long roomId) {
        ChatRoom chatRoom = chatRoomRepository.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found"));

        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        boolean isParticipant =  chatParticipantRepository.findByChatRoom(chatRoom)
                .stream().anyMatch(cp -> cp.getMember().getId() == member.getId());

        if(isParticipant) {
            throw new IllegalArgumentException("본인이 속한 채팅방이 아닙니다.");
        }

        //메세지 조회(시간순정렬)
        List<ChatMessage> chatMessageList = chatMessageRepository.findByChatRoomOrderByCreatedTimeAsc(chatRoom);

        List<ChatMessageDto> chatMessageDtos = chatMessageList.stream()
                .map(c -> ChatMessageDto.builder()
                        .message(c.getContent())
                        .senderEmail(c.getMember().getEmail())
                        .build())
                .collect(Collectors.toList());

        return chatMessageDtos;
    }

    /*
        채팅 메세지 저장
        1. 채팅방존재여부와 발신자정보 검증
        2. 메세지를 데이터베이스에 저장
        3. 해당 채팅방의 모든 참여자에 대해 읽음 상태를 생성
            -발신자는 자동으로 읽음 처리
            -다른참여자들은 모두 읽음X
        4.
     */
    public void saveMessage(ChatMessageDto chatMessageDto) {
        ChatRoom chatRoom = chatRoomRepository.findById(chatMessageDto.getRoomId())
                .orElseThrow(() -> new EntityNotFoundException("Room not found"));

        Member sender = memberRepository.findByEmail(chatMessageDto.getSenderEmail())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        ChatMessage chatMessage = ChatMessage.builder()
                .chatRoom(chatRoom)
                .member(sender)
                .content(chatMessageDto.getMessage())
                .build();

        chatMessageRepository.save(chatMessage);

        List<ChatParticipant> participants = chatParticipantRepository.findByChatRoom(chatRoom);
        List<ReadStatus> readStatuses = participants.stream()
                .map(c -> ReadStatus.builder()
                        .chatRoom(chatRoom)
                        .member(c.getMember())
                        .chatMessage(chatMessage)
                        .isRead(c.getMember().equals(sender))
                        .build())
                .toList();

        readStatusRepository.saveAll(readStatuses);
    }
    
    /*
        그룹채팅방 조회
        1. isGroupChat = 'Y'인 채팅방만 필터링해서 조회
        2. 채팅방정보를 dto로 변환해서 반환
     */
    public List<ChatRoomResponse> getGroupChatRooms() {
        List<ChatRoom> chatRooms = chatRoomRepository.findByIsGroupChat("Y");
        List<ChatRoomResponse> dtos =  chatRooms.stream()
                .map(c -> ChatRoomResponse.builder()
                        .roomId(c.getId())
                        .roomName(c.getName())
                        .build())
                .toList();
        return dtos;
    }

    /*
        그룹채팅방 생성
        1. 현재 로그인한 사용자 조회
        2. 그룹채팅방 만들기
        3. 로그인한 사용자를 첫번째 참여자로 등록
     */
    public Long createGroupChatRoom(String roomName) {
        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        ChatRoom chatRoom = ChatRoom.builder()
                .name(roomName)
                .isGroupChat("Y")
                .build();
        chatRoomRepository.save(chatRoom);

        ChatParticipant chatParticipant = ChatParticipant.builder()
                        .chatRoom(chatRoom)
                        .member(member)
                        .build();
        chatParticipantRepository.save(chatParticipant);

        return chatRoom.getId();
    }

    /*
        그룹채팅방 참여
        1. 채팅방 조회
        2. 현재 사용자가 참여중인지 여부 확인
        3. 참여자로 등록X -> 새로운 참여자로 등록
     */
    public void addParticipantToGroupChat(Long roomId) {
        ChatRoom chatRoom = chatRoomRepository.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found"));

        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        if(chatRoom.getIsGroupChat().equals("N")){
            throw new IllegalArgumentException("그룹 채팅이 아닙니다.");
        }

        Optional<ChatParticipant> participant = chatParticipantRepository.findByChatRoomAndMember(chatRoom, member);
        if(!participant.isPresent()) {
            addParticipantToRoom(chatRoom, member);
        }

    }

    /*
        내 채팅방 목록 조회
        
        1. 로그인한 사용자 정보 가져오기
        2. 사용자가 속한 채팅방 목록 가져오기
        3. 각 채팅방마다 읽지 않은 메세지 수를 계산
        4. 모든 정보를 dto로 만들어서 반환
     */
    public List<MyChatResponse> getMyChatRooms() {
        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        List<ChatParticipant> chatParticipants = chatParticipantRepository.findAllByMember(member);

        List<MyChatResponse> dtos = chatParticipants.stream()
                .map(c -> {
                    //각 채팅방의 읽지않은 메세지 수 조회
                    Long count = readStatusRepository.countByChatRoomAndMemberAndIsReadFalse(c.getChatRoom(), member);

                    return MyChatResponse.builder()
                            .roomId(c.getChatRoom().getId())
                            .roomName(c.getChatRoom().getName())
                            .isGroupChat(c.getChatRoom().getIsGroupChat())
                            .unReadCount(count)
                            .build();
                })
                .collect(Collectors.toList());

        return dtos;
    }

    /*
        메세지 읽음 처리

        1. 채팅방과 사용자의 정보를 확인
        2. 해당 사용자의 해당 방의 모든 읽지 않은 메세지를 읽음 상태로 변경
     */
    public void messageRead(Long roomId) {
        ChatRoom chatRoom = chatRoomRepository.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found"));

        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        List<ReadStatus> readStatuses = readStatusRepository.findByChatRoomAndMemberAndIsReadFalse(chatRoom, member);
        for(ReadStatus r : readStatuses){
            r.updateIsRead(true);
        }
    }

    /*
        채팅방 참여자 목록 제외(채팅방 나가기)

        1. 현재 사용자정보 가져오기
        2. 채팅방 정보 가져오기
        3. 사용자를 채팅방의 참여자목록에서 제거
        4. 혹시 마지막 참여자라면 채팅방 자체를 삭제
     */
    public void leaveGroupChatRoom(Long roomId) {
        ChatRoom chatRoom = chatRoomRepository.findById(roomId)
                .orElseThrow(() -> new EntityNotFoundException("Room not found"));

        Member member = memberRepository.findByEmail(jwtTokenProvider.getUserEmailFromToken())
                .orElseThrow(() -> new EntityNotFoundException("Member not found"));

        if(chatRoom.getIsGroupChat().equals("N")){
            throw new IllegalArgumentException("단체 채팅방이 아닙니다.");
        }

        ChatParticipant c = chatParticipantRepository.findByChatRoomAndMember(chatRoom, member)
                .orElseThrow(() -> new EntityNotFoundException("참여자를 찾을 수 없습니다."));
        chatParticipantRepository.delete(c);

        //남은 참여자가 없다면 채팅방 삭제
        List<ChatParticipant> chatParticipants = chatParticipantRepository.findByChatRoom(chatRoom);
        if(chatParticipants.isEmpty()){
            chatRoomRepository.delete(chatRoom);
        }
    }

}
