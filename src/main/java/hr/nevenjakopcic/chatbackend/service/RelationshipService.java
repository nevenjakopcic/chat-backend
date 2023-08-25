package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.RelationshipDto;
import hr.nevenjakopcic.chatbackend.mapper.RelationshipDtoMapper;
import hr.nevenjakopcic.chatbackend.repository.RelationshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RelationshipService {

    private final RelationshipRepository relationshipRepository;

    @Transactional(readOnly = true)
    public List<RelationshipDto> getAllRelationshipsOfUser(Long userId) {
        return relationshipRepository.getAllRelationshipsOfUser(userId).stream()
                .map(RelationshipDtoMapper::map)
                .collect(Collectors.toList());
    }
}
