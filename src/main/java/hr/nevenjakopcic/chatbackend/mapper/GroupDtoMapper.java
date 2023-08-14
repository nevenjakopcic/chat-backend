package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.GroupWithMembersDto;
import hr.nevenjakopcic.chatbackend.model.Group;

import java.util.stream.Collectors;

public class GroupDtoMapper {

    public static GroupWithMembersDto map(Group source) {
        return GroupWithMembersDto.builder()
                .id(source.getId())
                .name(source.getName())
                .createdAt(source.getCreatedAt())
                .lastActivity(source.getLastActivity())
                .members(source.getMembers()
                        .stream()
                        .map(MemberDtoMapper::map)
                        .collect(Collectors.toList()))
                .build();
    }

    private GroupDtoMapper() {}
}
