package hr.nevenjakopcic.chatbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Member", schema = "social")
@Entity(name = "Member")
public class Member {

    @EmbeddedId
    private MemberId memberId;

    @Enumerated(EnumType.ORDINAL)
    @Column(name = "roleId", nullable = false)
    private MemberRoles role;

    @Column(name = "joinedAt", nullable = false)
    private LocalDateTime joinedAt;
}
