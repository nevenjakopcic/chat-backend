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
public class GroupMessageDto implements Serializable {

    @Serial
    private static final long serialVersionUID = -4778122552846805358L;

    private Long id;
    private Long authorId;
    private Long groupId;
    private String content;
    private LocalDateTime createdAt;
}
