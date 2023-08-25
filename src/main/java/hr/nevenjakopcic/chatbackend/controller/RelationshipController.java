package hr.nevenjakopcic.chatbackend.controller;

import hr.nevenjakopcic.chatbackend.dto.ApiResponse;
import hr.nevenjakopcic.chatbackend.service.RelationshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/relationship")
@RequiredArgsConstructor
public class RelationshipController {

    private final RelationshipService relationshipService;

    @GetMapping("/user/{id}")
    public ResponseEntity<ApiResponse> getAllRelationshipsOfUser(@PathVariable final Long id){
        return new ResponseEntity<>(new ApiResponse(relationshipService.getAllRelationshipsOfUser(id)), HttpStatus.OK);
    }
}
