package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.RelationshipDto;
import hr.nevenjakopcic.chatbackend.model.Relationship;

public class RelationshipDtoMapper {

    public static RelationshipDto map(Relationship source) {
        return RelationshipDto.builder()
                .user1Id(source.getRelationshipId().getUser1().getId())
                .user2Id(source.getRelationshipId().getUser2().getId())
                .status(source.getStatus().toString())
                .lastUpdatedAt(source.getLastUpdatedAt())
                .build();
    }

    private RelationshipDtoMapper() {}
}
