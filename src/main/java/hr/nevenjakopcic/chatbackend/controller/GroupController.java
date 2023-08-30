package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.dto.request.CreateGroupRequest;
import hr.nevenjakopcic.chatbackend.dto.websocket.IncomingMessage;
import hr.nevenjakopcic.chatbackend.service.GroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/group")
@RequiredArgsConstructor
public class GroupController {

    private final GroupService groupService;

    @GetMapping
    public ResponseEntity<ApiResponse> getAllGroupsInfo() {
        return new ResponseEntity<>(new ApiResponse(groupService.getAllGroups()), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getGroupInfoAndMembers(@PathVariable Long id) {
        return new ResponseEntity<>(new ApiResponse(groupService.getGroupAndMembers(id)), HttpStatus.OK);
    }

    @PostMapping("/create")
    public ResponseEntity<ApiResponse> createGroup(@RequestBody CreateGroupRequest request) {
        return new ResponseEntity<>(new ApiResponse(groupService.createGroup(request)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}/last/{n}")
    public ResponseEntity<ApiResponse> getLastNGroupMessages(@PathVariable final Long id, @PathVariable final Long n) {
        return new ResponseEntity<>(new ApiResponse(groupService.getLastNGroupMessages(id, n)), HttpStatus.OK);
    }

    @PostMapping("/{id}")
    public ResponseEntity<ApiResponse> sendMessage(@PathVariable final Long id, @RequestBody IncomingMessage request) {
        return new ResponseEntity<>(new ApiResponse(groupService.sendGroupMessage(id, request)), HttpStatus.CREATED);
    }

    @DeleteMapping("/{id}/leave")
    public ResponseEntity<ApiResponse> leaveGroup(@PathVariable final Long id) {
        groupService.leaveGroup(id);

        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/promote/{memberId}")
    public ResponseEntity<ApiResponse> promoteMemberToAdmin(@PathVariable final Long id, @PathVariable final Long memberId) {
        groupService.promoteMemberToAdmin(id, memberId);

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}/kick/{memberId}")
    public ResponseEntity<ApiResponse> kickMemberFromGroup(@PathVariable final Long id, @PathVariable final Long memberId) {
        groupService.kickMemberFromGroup(id, memberId);

        return ResponseEntity.ok().build();
    }
}
