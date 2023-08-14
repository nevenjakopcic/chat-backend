package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.response.GroupDto;
import hr.nevenjakopcic.chatbackend.dto.response.GroupWithMembersDto;
import hr.nevenjakopcic.chatbackend.exception.NotFoundException;
import hr.nevenjakopcic.chatbackend.mapper.GroupDtoMapper;
import hr.nevenjakopcic.chatbackend.mapper.GroupWithMembersDtoMapper;
import hr.nevenjakopcic.chatbackend.model.Group;
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
    public List<GroupDto> getAllGroups() {
        return groupRepository.findAll().stream()
                .map(GroupDtoMapper::map)
                .collect(Collectors.toList());
    }

    public GroupWithMembersDto getGroupAndMembers(Long groupId) {
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException(String.format("Group with id %d not found.", groupId)));

        return GroupWithMembersDtoMapper.map(group);
    }
}
