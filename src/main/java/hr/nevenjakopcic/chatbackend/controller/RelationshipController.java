package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.CurrentUserService;
import hr.nevenjakopcic.chatbackend.service.RelationshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
