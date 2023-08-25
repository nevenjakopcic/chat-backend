package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.RelationshipDto;
import hr.nevenjakopcic.chatbackend.model.Relationship;
import hr.nevenjakopcic.chatbackend.model.RelationshipStatuses;
import hr.nevenjakopcic.chatbackend.model.SimpleRelationshipStatuses;
import hr.nevenjakopcic.chatbackend.model.User;

public class RelationshipDtoMapper {

    public static RelationshipDto map(Relationship source, Long currentUserId) {
        User otherUser = currentUserId.equals(source.getRelationshipId().getUser1().getId())
                       ? source.getRelationshipId().getUser2()
                       : source.getRelationshipId().getUser1();

        SimpleRelationshipStatuses simpleStatus = SimpleRelationshipStatuses.INVALID;

        if (source.getStatus().equals(RelationshipStatuses.FRIENDS)) {
            simpleStatus = SimpleRelationshipStatuses.FRIEND;
        } else if (source.getStatus().equals(RelationshipStatuses.BLOCK_BOTH)) {
            simpleStatus = SimpleRelationshipStatuses.BLOCK_BOTH;
        }

        // User1 is currently logged-in user
        if (source.getRelationshipId().getUser1().getId().equals(currentUserId)) {
            switch (source.getStatus()) {
                case PENDING_FIRST_SECOND -> simpleStatus = SimpleRelationshipStatuses.SENT_FRIEND_REQUEST;
                case PENDING_SECOND_FIRST -> simpleStatus = SimpleRelationshipStatuses.PENDING_FRIEND_REQUEST;
                case BLOCK_FIRST_SECOND   -> simpleStatus = SimpleRelationshipStatuses.BLOCKING;
                case BLOCK_SECOND_FIRST   -> simpleStatus = SimpleRelationshipStatuses.BLOCKED_BY;
            }
        } else {
            switch (source.getStatus()) {
                case PENDING_SECOND_FIRST -> simpleStatus = SimpleRelationshipStatuses.SENT_FRIEND_REQUEST;
                case PENDING_FIRST_SECOND -> simpleStatus = SimpleRelationshipStatuses.PENDING_FRIEND_REQUEST;
                case BLOCK_SECOND_FIRST   -> simpleStatus = SimpleRelationshipStatuses.BLOCKING;
                case BLOCK_FIRST_SECOND   -> simpleStatus = SimpleRelationshipStatuses.BLOCKED_BY;
            }
        }

        return RelationshipDto.builder()
                .otherUser(UserDtoMapper.map(otherUser))
                .status(simpleStatus.toString())
                .lastUpdatedAt(source.getLastUpdatedAt())
                .build();
    }

    private RelationshipDtoMapper() {}
}
