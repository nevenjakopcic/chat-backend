package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.CurrentUserService;
import hr.nevenjakopcic.chatbackend.service.RelationshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/relationship")
@RequiredArgsConstructor
public class RelationshipController {

    private final RelationshipService relationshipService;
    private final CurrentUserService currentUserService;

    @GetMapping("/user")
    public ResponseEntity<ApiResponse> getAllRelationshipsOfCurrentUser() {
        Long currentUserId = currentUserService.getCurrentUserId();

        return new ResponseEntity<>(new ApiResponse(relationshipService.getAllRelationshipsOfUser(currentUserId)), HttpStatus.OK);
    }

    @PostMapping("/friend-request/{targetUserId}")
    public ResponseEntity<ApiResponse> sendFriendRequest(@PathVariable final Long targetUserId) {
        Long currentUserId = currentUserService.getCurrentUserId();

        relationshipService.sendFriendRequest(currentUserId, targetUserId);

        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PutMapping("/friend-request/accept/{requesterId}")
    public ResponseEntity<ApiResponse> acceptFriendRequest(@PathVariable final Long requesterId) {
        Long currentUserId = currentUserService.getCurrentUserId();

        relationshipService.acceptFriendRequest(currentUserId, requesterId);

        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @DeleteMapping("/friend-request/reject/{requesterId}")
    public ResponseEntity<ApiResponse> rejectFriendRequest(@PathVariable final Long requesterId) {
        Long currentUserId = currentUserService.getCurrentUserId();

        relationshipService.rejectFriendRequest(currentUserId, requesterId);

        return ResponseEntity.status(HttpStatus.OK).build();
    }
}
