# Cumulocity Microservice: ${microserviceName}

Short description of what this microservice does and why it exists. Replace this text with a one-paragraph summary.

# Features
- Describe key capabilities in short bullets

# API
- Describe any exposed REST API endpoints, request/response formats, and usage examples.

# Prerequisites
- Java 17+ and Maven 3.8+
- Docker (optional, for container builds)
- Access to a Cumulocity tenant (URL, tenant ID, and credentials or bootstrap user)
- go-c8y-cli installed and session configured to your development tenant

# Quickstart
- Clone repository
- Open in IDE (e.g., VSCode, IntelliJ)
- Build with Maven: `mvn clean package`
- Run initializr script to your development tenant:
    - on Windows: `.\initializr.ps1`
    - on Linux/Mac: `./initializr.sh`
- Run locally in IDE or directly with java: `java -jar target/${artifactId}-${version}.jar`

# Cumulocity Tenant Configuration
The initializr script configures via go-c8y-cli the `.env\dev.env` file with:
- C8Y_BASEURL: https://<tenant-domain>
- C8Y_TENANT: <tenant-id>
- C8Y_USER: <username> (or bootstrap user)
- C8Y_PASSWORD: <password>
- MICROSERVICE_ISOLATION: MULTI_TENANT (or SINGLE_TENANT)

# Docker Build
- In order to enable docker build, set the following property in pom.xml:

```xml
<c8y.docker.skip>false</c8y.docker.skip>
```

# Logging and Monitoring
- Logs: standard out; configure via application properties (e.g., log level).
- Health and metrics: Spring Boot Actuator (if enabled) at `/actuator/*`.

# Contributing
- Create feature branches and open PRs.
- Keep commits small and well-described.
- Add/maintain tests and docs for new changes.

# License
- Specify your license here (e.g., MIT, Apache-2.0).

# Useful links 

📘 Explore the Knowledge Base   
Dive into a wealth of Cumulocity IoT tutorials and articles in our [Tech Community](https://techcommunity.cumulocity.com).  

💡 Get Expert Answers    
Stuck or just curious? Ask the Cumulocity IoT experts directly on our [Forum](https://techcommunity.cumulocity.com/c/forum/5).   

🚀 Try Cumulocity IoT    
See Cumulocity IoT in action with a [Free Trial](https://www.cumulocity.com/start-your-journey/free-trial).   

✍️ Share Your Feedback    
Your input drives our innovation. If you find a bug, please create an issue in the repository. If you'd like to share your ideas or feedback, please post them [here](https://techcommunity.cumulocity.com/c/feedback-ideas/14). 