package hr.nevenjakopcic.chatbackend.dto.websocket;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class IncomingMessage {

    private Long authorId;
    private String content;
}
