package main;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(
    scanBasePackages = {"main", "controller", "service", "repository", "model", "security"})
@EntityScan("model")
@EnableJpaRepositories("repository")
public class MoebelHausApplication {
  public static void main(String[] args) {
    SpringApplication.run(MoebelHausApplication.class, args);
  }
}
