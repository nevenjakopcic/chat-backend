package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.LoginDto;
import hr.nevenjakopcic.chatbackend.model.User;

public class LoginDtoMapper {

    public static LoginDto map(User source) {
        return LoginDto.builder()
                .id(source.getId())
                .username(source.getUsername())
                .build();
    }

    private LoginDtoMapper() {}
}
