package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.PrivateMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/private")
@RequiredArgsConstructor
public class PrivateConversationController {

    private final PrivateMessageService privateMessageService;

    @GetMapping("/{otherUserId}/last/{n}")
    public ResponseEntity<ApiResponse> getLastNPrivateMessages(
            @PathVariable final Long otherUserId,
            @PathVariable final Long n) {
        return new ResponseEntity<>(new ApiResponse(
                privateMessageService.getLastNPrivateMessages(otherUserId, n)),
                HttpStatus.OK
        );
    }

    @GetMapping("/{otherUserId}/last/{n}/after/{lastMessageId}")
    public ResponseEntity<ApiResponse> getLastNPrivateMessagesAfterSpecific(
            @PathVariable final Long otherUserId,
            @PathVariable final Long n,
            @PathVariable final Long lastMessageId) {
        return new ResponseEntity<>(new ApiResponse(
                privateMessageService.getLastNPrivateMessagesAfterSpecific(otherUserId, n, lastMessageId)),
                HttpStatus.OK);
    }
}
