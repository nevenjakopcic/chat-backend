package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.UserDto;
import hr.nevenjakopcic.chatbackend.model.User;

public class UserDtoMapper {

    public static UserDto map(User source) {
        return UserDto.builder()
            .id(source.getId())
            .username(source.getUsername())
            .lastOnline(source.getLastOnline())
            .joinedAt(source.getJoinedAt())
            .build();
    }

    private UserDtoMapper() {}
}