package hr.nevenjakopcic.chatbackend.service;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CurrentUserService {

    public Long getCurrentUserId() {
        String name = SecurityContextHolder.getContext().getAuthentication().getName();

        return Long.valueOf(name.substring(0, name.indexOf(",")));
    }
}
