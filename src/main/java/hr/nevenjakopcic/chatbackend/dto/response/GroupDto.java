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
public class GroupDto implements Serializable {

    @Serial
    private static final long serialVersionUID = -689824610303334217L;

    private Long id;
    private String name;
    private LocalDateTime createdAt;
    private LocalDateTime lastActivity;
}