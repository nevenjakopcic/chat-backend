package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.UserDto;
import hr.nevenjakopcic.chatbackend.model.User;

public class UserDtoMapper {

    public static UserDto map(User source) {
        return UserDto.builder()
            .id(source.getId())
            .username(source.getUsername())
            .email(source.getEmail())
            .lastOnline(source.getLastOnline())
            .userSince(source.getJoinedAt())
            .build();
    }

    private UserDtoMapper() {}
}