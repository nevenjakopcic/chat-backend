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
@Table(name = "Relationship", schema = "social")
@Entity(name = "Relationship")
public class Relationship {

    @EmbeddedId
    private RelationshipId relationshipId;

    @Enumerated(EnumType.ORDINAL)
    @Column(name = "statusId", nullable = false)
    private RelationshipStatuses status;

    @Column(name = "lastUpdatedAt", nullable = false)
    private LocalDateTime lastUpdatedAt;
}
