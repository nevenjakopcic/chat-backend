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
    private static final long serialVersionUID = -4959840925228112117L;

    private UserDto otherUser;
    private String status;
    private LocalDateTime lastUpdatedAt;
}