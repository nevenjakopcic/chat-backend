package hr.nevenjakopcic.chatbackend.service;

import hr.nevenjakopcic.chatbackend.dto.request.CreateGroupRequest;
import hr.nevenjakopcic.chatbackend.dto.response.GroupDto;
import hr.nevenjakopcic.chatbackend.dto.response.GroupMessageDto;
import hr.nevenjakopcic.chatbackend.dto.response.GroupWithMembersDto;
import hr.nevenjakopcic.chatbackend.dto.websocket.IncomingMessage;
import hr.nevenjakopcic.chatbackend.exception.NotFoundException;
import hr.nevenjakopcic.chatbackend.mapper.GroupDtoMapper;
import hr.nevenjakopcic.chatbackend.mapper.GroupMessageDtoMapper;
import hr.nevenjakopcic.chatbackend.mapper.GroupWithMembersDtoMapper;
import hr.nevenjakopcic.chatbackend.model.Group;
import hr.nevenjakopcic.chatbackend.repository.GroupMessageRepository;
import hr.nevenjakopcic.chatbackend.repository.GroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final CurrentUserService currentUserService;

    private final GroupRepository groupRepository;
    private final GroupMessageRepository messageRepository;

    @Transactional(readOnly = true)
    public List<GroupDto> getAllGroups() {
        return groupRepository.findAll().stream()
                .map(GroupDtoMapper::map)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public GroupWithMembersDto getGroupAndMembers(Long groupId) {
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new NotFoundException(String.format("Group with id %d not found.", groupId)));

        return GroupWithMembersDtoMapper.map(group);
    }

    @Transactional
    public GroupDto createGroup(CreateGroupRequest request) {
        Group group = groupRepository.createGroup(request.getName());

        Long currentUserId = currentUserService.getCurrentUserId();
        groupRepository.addAdmin(group.getId(), currentUserId);

        return GroupDtoMapper.map(group);
    }

    @Transactional(readOnly = true)
    public List<GroupMessageDto> getLastNGroupMessages(Long groupId, Long n) {
        return messageRepository.getLastNGroupMessages(groupId, n).stream()
                .map(GroupMessageDtoMapper::map)
                .collect(Collectors.toList());
    }

    @Transactional
    public GroupMessageDto sendGroupMessage(Long groupId, IncomingMessage message) {
        messageRepository.sendGroupMessage(
                message.getAuthorId(),
                groupId,
                message.getContent());

        return getLastNGroupMessages(groupId, 1L).get(0);
    }

    @Transactional
    public void leaveGroup(Long groupId) {
        Long memberId = currentUserService.getCurrentUserId();

        groupRepository.kickMemberFromGroup(groupId, memberId);
    }

    @Transactional
    public void promoteMemberToAdmin(Long groupId, Long memberId) {
        groupRepository.promoteMemberToAdmin(groupId, memberId);
    }

    @Transactional
    public void kickMemberFromGroup(Long groupId, Long memberId) {
        groupRepository.kickMemberFromGroup(groupId, memberId);
    }
}
