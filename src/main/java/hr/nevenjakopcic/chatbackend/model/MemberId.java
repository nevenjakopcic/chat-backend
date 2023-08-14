package hr.nevenjakopcic.chatbackend.model;

import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class MemberId implements Serializable {

    @ManyToOne(optional = false)
    @JoinColumn(name = "groupId", nullable = false)
    private Group group;

    @ManyToOne(optional = false)
    @JoinColumn(name = "userId", nullable = false)
    private User user;
}
