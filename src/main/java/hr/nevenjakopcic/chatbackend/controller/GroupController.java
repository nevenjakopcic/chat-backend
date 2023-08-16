package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.GroupService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/group")
@AllArgsConstructor
@CrossOrigin
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

    @GetMapping("/{id}/last/{n}")
    public ResponseEntity<ApiResponse> getLastNGroupMessages(@PathVariable final Long id, @PathVariable final Long n) {
        return new ResponseEntity<>(new ApiResponse(groupService.getLastNGroupMessages(id, n)), HttpStatus.OK);
    }
}
