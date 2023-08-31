package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.response.GroupMessageDto;
import hr.nevenjakopcic.chatbackend.dto.response.PrivateMessageDto;
import hr.nevenjakopcic.chatbackend.dto.websocket.IncomingMessage;
import hr.nevenjakopcic.chatbackend.service.GroupService;
import hr.nevenjakopcic.chatbackend.service.PrivateMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@MessageMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate template;

    private final GroupService groupService;
    private final PrivateMessageService privateMessageService;

    @MessageMapping("/group/{groupId}")
    @SendTo("/topic/messages/group/{groupId}")
    public GroupMessageDto sendGroupMessage(@DestinationVariable Long groupId, IncomingMessage message) {
        return groupService.sendGroupMessage(groupId, message);
    }

    @MessageMapping("/private/{recipientId}")
    public void sendPrivateMessage(@DestinationVariable Long recipientId, IncomingMessage message) {

        PrivateMessageDto dto = privateMessageService.sendPrivateMessage(recipientId, message);

        String dest;
        if (dto.getAuthorId() < dto.getRecipientId()) {
            dest = String.format("/topic/messages/private/%d/%d", dto.getAuthorId(), dto.getRecipientId());
        } else {
            dest = String.format("/topic/messages/private/%d/%d", dto.getRecipientId(), dto.getAuthorId());
        }

        template.convertAndSend(dest, dto);
    }
}
