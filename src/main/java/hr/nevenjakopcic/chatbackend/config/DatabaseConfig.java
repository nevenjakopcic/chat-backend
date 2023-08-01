package hr.nevenjakopcic.chatbackend.config;

import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@AllArgsConstructor
@Configuration
public class DatabaseConfig {

    private final DataSource dataSource;

/*
    @Bean
    public JdbcTemplate jdbcTemplate() {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.execute("EXEC sp_setapprole 'chatapp', 'chatapp'");
        return jdbcTemplate;
    }
*/

    @Bean
    public JdbcTemplate jdbcTemplate() {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.execute("EXECUTE AS USER = 'imp_user'");
        return jdbcTemplate;
    }
}