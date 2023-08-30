package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.GroupMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupMessageRepository extends JpaRepository<GroupMessage, Long> {

    @Procedure(procedureName = "io.usp_GetLastNGroupMessages")
    List<GroupMessage> getLastNGroupMessages(Long groupId, Long n);

    @Procedure(procedureName = "io.usp_GetLastNGroupMessagesAfterSpecific")
    List<GroupMessage> getLastNGroupMessagesAfterSpecific(Long groupId, Long n, Long lastMessageId);

    @Procedure(procedureName = "io.usp_SendGroupMessage")
    void sendGroupMessage(Long authorId, Long groupId, String content);
}
