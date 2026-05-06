package security;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

  private final JwtAuthFilter jwtAuthFilter;

  @Value("${cors.allowed-origins}")
  private String[] allowedOrigins;

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    return http.cors(c -> c.configurationSource(corsSource()))
        .csrf(c -> c.disable())
        .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(
            auth ->
                auth
                    // 1. Statische Ressourcen für die Optik erlauben
                    .requestMatchers(
                        "/", "/index.html", "/static/**", "/css/**", "/js/**", "/*.css", "/*.js")
                    .permitAll()

                    // 2. Auth-Endpunkte (Login/Register) erlauben
                    .requestMatchers("/api/auth/**")
                    .permitAll()

                    // 3. Alle anderen API-Aufrufe schützen
                    .requestMatchers("/api/**")
                    .authenticated()

                    // 4. Alles andere (z.B. Fehlerseiten) erlauben
                    .anyRequest()
                    .permitAll())
        // JWT Filter hinzufügen, sonst schlägt die Authentifizierung fehl
        .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
        .build();
  }

  @Bean
  public CorsConfigurationSource corsSource() {
    var config = new CorsConfiguration();
    config.setAllowedOrigins(List.of(allowedOrigins));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    config.setAllowedHeaders(List.of("*"));
    config.setAllowCredentials(true);
    var source = new UrlBasedCorsConfigurationSource();
    // WICHTIG: CORS auch für statische Pfade zulassen, falls nötig
    source.registerCorsConfiguration("/**", config);
    return source;
  }

  @Bean
  public PasswordEncoder passwordEncoder() {
    // Hinweis: NoOpPasswordEncoder ist unsicher (nur für Tests!),
    // aber für die Fehlersuche jetzt okay.
    return org.springframework.security.crypto.password.NoOpPasswordEncoder.getInstance();
  }

  @Bean
  public AuthenticationManager authManager(AuthenticationConfiguration config) throws Exception {
    return config.getAuthenticationManager();
  }
}
