package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.response.GroupMessageDto;
import hr.nevenjakopcic.chatbackend.dto.websocket.IncomingMessage;
import hr.nevenjakopcic.chatbackend.service.GroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
@MessageMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final GroupService groupService;

    @MessageMapping("/group/{groupId}")
    @SendTo("/topic/messages/group/{groupId}")
    public GroupMessageDto sendGroupMessage(@DestinationVariable Long groupId, IncomingMessage message) {
        return groupService.sendGroupMessage(groupId, message);
    }
}
