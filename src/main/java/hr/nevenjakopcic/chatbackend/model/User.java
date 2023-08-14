package hr.nevenjakopcic.chatbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "`User`", schema = "social")
@Entity(name = "User")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "username", nullable = false, unique = true)
    private String username;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "lastOnline", nullable = false)
    private LocalDateTime lastOnline;

    @Column(name = "joinedAt", nullable = false)
    private LocalDateTime joinedAt;

    @OneToMany(mappedBy = "memberId.user")
    private List<Member> members;
}