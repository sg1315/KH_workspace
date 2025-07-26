package com.kh.login.repository.chat;

import com.kh.login.domain.Member;
import com.kh.login.domain.chat.ChatParticipant;
import com.kh.login.domain.chat.ChatRoom;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatParicipantRepository extends JpaRepository<ChatParticipant, Long> {
    Optional<ChatParticipant> findByChatRoomAndMember(ChatRoom chatRoom, Member member);

    List<ChatParticipant> findByChatRoom(ChatRoom chatRoom);
    List<ChatParticipant> findAllByMember(Member member);


    //두 사용자가 함께 참여하고 있는 1:1 채팅방
    @Query("""
        SELECT cp1.chatRoom
        FROM ChatParticipant cp1
        WHERE cp1.chatRoom.isGroupChat = 'N'
        AND cp1.chatRoom.id IN (
            SELECT cp2.chatRoom.id
            FROM ChatParticipant cp2
            WHERE cp2.member.id =: myId OR cp2.member.id =: otherId
            GROUP BY cp2.chatRoom.id
            HAVING COUNT(DISTINCT cp2.member.id) = 2
        )
    """)
    Optional<ChatRoom> findExistingPrivateRoom(@Param("myId") Long myId, @Param("otherId") Long otherId);

}
