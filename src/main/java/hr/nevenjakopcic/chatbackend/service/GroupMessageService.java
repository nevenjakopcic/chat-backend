package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.GroupMessageDto;
import hr.nevenjakopcic.chatbackend.mapper.GroupMessageDtoMapper;
import hr.nevenjakopcic.chatbackend.repository.GroupMessageRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class GroupMessageService {

    private final GroupMessageRepository groupMessageRepository;

    @Transactional(readOnly = true)
    public List<GroupMessageDto> getLastNGroupMessages(Long groupId, Long n) {
        return groupMessageRepository.getLastNGroupMessages(groupId, n).stream()
                                                                       .map(GroupMessageDtoMapper::map)
                                                                       .collect(Collectors.toList());
    }
}
