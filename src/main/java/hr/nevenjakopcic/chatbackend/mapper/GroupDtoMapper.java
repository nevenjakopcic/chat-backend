package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.GroupDto;
import hr.nevenjakopcic.chatbackend.model.Group;

public class GroupDtoMapper {

    public static GroupDto map(Group source) {
        return GroupDto.builder()
                .id(source.getId())
                .name(source.getName())
                .createdAt(source.getCreatedAt())
                .lastActivity(source.getLastActivity())
                .build();
    }

    private GroupDtoMapper() {}
}
