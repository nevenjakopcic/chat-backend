package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

    @Procedure(procedureName = "social.usp_GetGroupsWithMember")
    List<Group> getGroupsWithMember(Long userId);

    @Procedure(procedureName = "social.usp_PromoteMemberToAdmin")
    void promoteMemberToAdmin(Long groupId, Long userId);

    @Procedure(procedureName = "social.usp_KickMemberFromGroup")
    void kickMemberFromGroup(Long groupId, Long userId);

    @Procedure(procedureName = "social.usp_CreateGroup")
    Group createGroup(String name);

    @Procedure(procedureName = "social.usp_AddMember")
    void addMember(Long groupId, Long userId);

    @Procedure(procedureName = "social.usp_AddAdmin")
    void addAdmin(Long groupId, Long userId);
}
