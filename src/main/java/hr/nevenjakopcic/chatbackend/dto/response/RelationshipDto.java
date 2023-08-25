package hr.nevenjakopcic.chatbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RelationshipDto implements Serializable {

    @Serial
    private static final long serialVersionUID = 71147003125862205L;

    private Long user1Id;
    private Long user2Id;
    private String status;
    private LocalDateTime lastUpdatedAt;
}