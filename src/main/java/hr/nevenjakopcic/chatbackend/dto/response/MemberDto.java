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
public class MemberDto implements Serializable {

    @Serial
    private static final long serialVersionUID = -7753175180389203295L;

    private Long id;
    private String username;
    private LocalDateTime lastOnline;
    private LocalDateTime userSince;
    private String role;
    private LocalDateTime memberSince;
}
