package hr.nevenjakopcic.chatbackend.mapper;

import hr.nevenjakopcic.chatbackend.dto.response.MemberDto;
import hr.nevenjakopcic.chatbackend.model.Member;

public class MemberDtoMapper {

        public static MemberDto map(Member source) {
        return MemberDto.builder()
            .id(source.getMemberId().getUser().getId())
            .username(source.getMemberId().getUser().getUsername())
            .lastOnline(source.getMemberId().getUser().getLastOnline())
            .userSince(source.getMemberId().getUser().getJoinedAt())
            .role(source.getRole().name())
            .memberSince(source.getJoinedAt())
            .build();
    }

    private MemberDtoMapper() {}
}
