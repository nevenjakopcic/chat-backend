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

    @Transactional
    public void sendFriendRequest(Long requesterId, Long targetId) {
        relationshipRepository.sendFriendRequest(requesterId, targetId);
    }

    @Transactional
    public void acceptFriendRequest(Long acceptorId, Long requesterId) {
        relationshipRepository.acceptFriendRequest(acceptorId, requesterId);
    }

    @Transactional
    public void rejectFriendRequest(Long rejectorId, Long requesterId) {
        relationshipRepository.rejectFriendRequest(rejectorId, requesterId);
    }

    @Transactional
    public void removeFromFriends(Long removerId, Long friendId) {
        relationshipRepository.removeFromFriends(removerId, friendId);
    }
}
