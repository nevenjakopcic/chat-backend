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
public class UserDto implements Serializable {

    @Serial
    private static final long serialVersionUID = 2388293951524839797L;

    private Long id;
    private String username;
    private String email;
    private LocalDateTime lastOnline;
    private LocalDateTime joinedAt;
}