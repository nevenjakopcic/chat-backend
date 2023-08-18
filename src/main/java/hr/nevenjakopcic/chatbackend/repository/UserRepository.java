package hr.nevenjakopcic.chatbackend.repository;

import hr.nevenjakopcic.chatbackend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    @Procedure(procedureName = "social.usp_GetAllUsers")
    List<User> getAll();

    Optional<User> findByUsername(String username);

    @Procedure(procedureName = "social.usp_CreateUser")
    void createUser(String username, String password, String email);
}
