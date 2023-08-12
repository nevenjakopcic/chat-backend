package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.GroupService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/group")
@AllArgsConstructor
public class GroupController {

    private final GroupService groupService;

    @GetMapping
    public ResponseEntity<ApiResponse> getAllGroups() {
        return new ResponseEntity<>(new ApiResponse(groupService.getAll()), HttpStatus.OK);
    }
}
