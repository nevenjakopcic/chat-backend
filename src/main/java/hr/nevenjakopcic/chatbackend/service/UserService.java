package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.request.RegisterRequest;
import hr.nevenjakopcic.chatbackend.dto.response.UserDto;
import hr.nevenjakopcic.chatbackend.exception.NotFoundException;
import hr.nevenjakopcic.chatbackend.mapper.UserDtoMapper;
import hr.nevenjakopcic.chatbackend.model.User;
import hr.nevenjakopcic.chatbackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<UserDto> getAll() {
        return userRepository.findAll().stream()
                                      .map(UserDtoMapper::map)
                                      .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserDto getByUsername(String username) {
        User user = userRepository.findByUsername(username)
                                  .orElseThrow(() -> new NotFoundException(String.format("User with username %s not found.", username)));

        return UserDtoMapper.map(user);
    }

    public UserDto registerUser(RegisterRequest request) {
        // TODO: add checks for existing username
        // TODO: do something about roles

        request.setPassword(passwordEncoder.encode(request.getPassword()));

        userRepository.createUser(request.getUsername(), request.getPassword(), request.getEmail());

        return getByUsername(request.getUsername());
    }
}
