package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.PrivateMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PrivateMessageRepository extends JpaRepository<PrivateMessage, Long> {

    @Procedure(procedureName = "io.usp_GetLastNPrivateMessages")
    List<PrivateMessage> getLastNPrivateMessages(Long firstUserId, Long secondUserId, Long n);

    @Procedure(procedureName = "io.usp_GetLastNPrivateMessagesAfterSpecific")
    List<PrivateMessage> getLastNPrivateMessagesAfterSpecific(Long firstUserId, Long secondUserId, Long n, Long lastMessageId);

    @Procedure(procedureName = "io.usp_SendPrivateMessage")
    void sendPrivateMessage(Long authorId, Long recipientId, String content);
}
