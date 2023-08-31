package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.PrivateMessageDto;
import hr.nevenjakopcic.chatbackend.dto.websocket.IncomingMessage;
import hr.nevenjakopcic.chatbackend.mapper.PrivateMessageDtoMapper;
import hr.nevenjakopcic.chatbackend.repository.PrivateMessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PrivateMessageService {

    private final CurrentUserService currentUserService;

    private final PrivateMessageRepository messageRepository;

    @Transactional(readOnly = true)
    public List<PrivateMessageDto> getLastNPrivateMessages(Long otherUserId, Long n) {
        Long currentUserId = currentUserService.getCurrentUserId();

        return messageRepository
                .getLastNPrivateMessages(currentUserId, otherUserId, n).stream()
                .map(PrivateMessageDtoMapper::map)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PrivateMessageDto> getLastNPrivateMessages(Long firstUserId, Long secondUserId, Long n) {
        return messageRepository
                .getLastNPrivateMessages(firstUserId, secondUserId, n).stream()
                .map(PrivateMessageDtoMapper::map)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PrivateMessageDto> getLastNPrivateMessagesAfterSpecific(Long otherUserId, Long n, Long lastMessageId) {
        Long currentUserId = currentUserService.getCurrentUserId();

        return messageRepository
                .getLastNPrivateMessagesAfterSpecific(currentUserId, otherUserId, n, lastMessageId).stream()
                .map(PrivateMessageDtoMapper::map)
                .collect(Collectors.toList());
    }

    @Transactional
    public PrivateMessageDto sendPrivateMessage(Long recipientId, IncomingMessage message) {
        messageRepository
                .sendPrivateMessage(
                    message.getAuthorId(),
                    recipientId,
                    message.getContent());

        return getLastNPrivateMessages(message.getAuthorId(), recipientId, 1L).get(0);
    }
}
