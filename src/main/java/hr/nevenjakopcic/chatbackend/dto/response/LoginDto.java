package hr.nevenjakopcic.chatbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LoginDto implements Serializable {

    @Serial
    private static final long serialVersionUID = -4470258297563917190L;

    private Long id;
    private String username;
    private String token;
}
