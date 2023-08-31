package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.PrivateMessageDto;
import hr.nevenjakopcic.chatbackend.model.PrivateMessage;

public class PrivateMessageDtoMapper {

    public static PrivateMessageDto map(PrivateMessage source) {
        return PrivateMessageDto.builder()
                .id(source.getId())
                .authorId(source.getAuthorId())
                .recipientId(source.getRecipientId())
                .content(source.getContent())
                .createdAt(source.getCreatedAt())
                .build();
    }

    private PrivateMessageDtoMapper() {}
}
