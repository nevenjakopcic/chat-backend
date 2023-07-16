package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.GroupMessageDto;
import hr.nevenjakopcic.chatbackend.model.GroupMessage;

public class GroupMessageDtoMapper {

    public static GroupMessageDto map(GroupMessage source) {
        return GroupMessageDto.builder()
                .id(source.getId())
                .authorId(source.getAuthorId())
                .groupId(source.getGroupId())
                .content(source.getContent())
                .createdAt(source.getCreatedAt())
                .build();
    }

    private GroupMessageDtoMapper() {}
}
