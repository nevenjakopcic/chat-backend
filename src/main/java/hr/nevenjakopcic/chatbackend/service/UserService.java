package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.UserDto;
import hr.nevenjakopcic.chatbackend.exception.NotFoundException;
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
        return userRepository.getAll().stream()
                                      .map(UserDtoMapper::map)
                                      .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserDto getByUsername(String username) {
        User user = userRepository.getByUsername(username)
                                  .orElseThrow(() -> new NotFoundException(String.format("User with username %s not found.", username)));

        return UserDtoMapper.map(user);
    }
}
