package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

}
