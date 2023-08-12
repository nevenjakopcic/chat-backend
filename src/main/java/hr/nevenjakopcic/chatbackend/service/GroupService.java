package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.GroupDto;
import hr.nevenjakopcic.chatbackend.mapper.GroupDtoMapper;
import hr.nevenjakopcic.chatbackend.repository.GroupRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;

    @Transactional(readOnly = true)
    public List<GroupDto> getAll() {
        return groupRepository.getAll().stream()
                                      .map(GroupDtoMapper::map)
                                      .collect(Collectors.toList());
    }
}
