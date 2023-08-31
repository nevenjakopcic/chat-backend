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
public class PrivateMessageDto implements Serializable {

    @Serial
    private static final long serialVersionUID = -3443679759425564801L;

    private Long id;
    private Long authorId;
    private Long recipientId;
    private String content;
    private LocalDateTime createdAt;
}
