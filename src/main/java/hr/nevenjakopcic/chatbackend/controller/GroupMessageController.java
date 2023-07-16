package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.GroupMessageService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/group-message")
@AllArgsConstructor
public class GroupMessageController {

    private final GroupMessageService groupMessageService;

    @GetMapping("/group/{groupId}/last/{n}")
    public ResponseEntity<ApiResponse> getLastNGroupMessages(@PathVariable final Long groupId, @PathVariable final Long n) {
        return new ResponseEntity<>(new ApiResponse(groupMessageService.getLastNGroupMessages(groupId, n)), HttpStatus.OK);
    }
}
