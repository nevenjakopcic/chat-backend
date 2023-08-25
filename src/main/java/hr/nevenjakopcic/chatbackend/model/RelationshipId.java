package hr.nevenjakopcic.chatbackend.model;

import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class RelationshipId implements Serializable {

    @ManyToOne(optional = false)
    @JoinColumn(name = "user1Id", nullable = false)
    private User user1;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user2Id", nullable = false)
    private User user2;
}
