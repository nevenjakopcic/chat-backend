package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.Relationship;
import hr.nevenjakopcic.chatbackend.model.RelationshipId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.util.List;

public interface RelationshipRepository extends JpaRepository<Relationship, RelationshipId> {

    @Procedure(procedureName = "social.usp_GetAllRelationshipsOfUser")
    List<Relationship> getAllRelationshipsOfUser(Long userId);

    @Procedure(procedureName = "social.usp_SendFriendRequest")
    void sendFriendRequest(Long requesterId, Long targetId);

    @Procedure(procedureName = "social.usp_AcceptFriendRequest")
    void acceptFriendRequest(Long acceptorId, Long requesterId);

    @Procedure(procedureName = "social.usp_RejectFriendRequest")
    void rejectFriendRequest(Long rejectorId, Long requesterId);

    @Procedure(procedureName = "social.usp_RemoveFromFriends")
    void removeFromFriends(Long removerId, Long friendId);
}
