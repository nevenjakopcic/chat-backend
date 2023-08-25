package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.Relationship;
import hr.nevenjakopcic.chatbackend.model.RelationshipId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.util.List;

public interface RelationshipRepository extends JpaRepository<Relationship, RelationshipId> {

    @Procedure(procedureName = "social.usp_GetAllRelationshipsOfUser")
    List<Relationship> getAllRelationshipsOfUser(Long userId);
}
