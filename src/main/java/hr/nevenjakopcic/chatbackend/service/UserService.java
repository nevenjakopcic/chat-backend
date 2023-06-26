package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.UserDto;
import hr.nevenjakopcic.chatbackend.mapper.UserDtoMapper;
import hr.nevenjakopcic.chatbackend.model.User;
import hr.nevenjakopcic.chatbackend.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<UserDto> getAll() {
        List<User> users = userRepository.getAll();

        return users.stream().map(UserDtoMapper::map).collect(Collectors.toList());
    }
}
