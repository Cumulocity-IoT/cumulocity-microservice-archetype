package ${package};

import com.cumulocity.microservice.autoconfigure.MicroserviceApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@MicroserviceApplication
@RestController
public class App {
    public static void main (String[] args) {
        SpringApplication.run(App.class, args);
    }
}