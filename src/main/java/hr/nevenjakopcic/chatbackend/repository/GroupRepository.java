package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

    @Procedure(procedureName = "social.usp_GetAllGroups")
    List<Group> getAll();
}
