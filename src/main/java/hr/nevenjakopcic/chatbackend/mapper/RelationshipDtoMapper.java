package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.RelationshipDto;
import hr.nevenjakopcic.chatbackend.model.Relationship;
import hr.nevenjakopcic.chatbackend.model.User;

public class RelationshipDtoMapper {

    public static RelationshipDto map(Relationship source, Long currentUserId) {
        User otherUser = currentUserId.equals(source.getRelationshipId().getUser1().getId())
                       ? source.getRelationshipId().getUser2()
                       : source.getRelationshipId().getUser1();

        return RelationshipDto.builder()
                .otherUser(UserDtoMapper.map(otherUser))
                .status(source.getStatus().toString())
                .lastUpdatedAt(source.getLastUpdatedAt())
                .build();
    }

    private RelationshipDtoMapper() {}
}
