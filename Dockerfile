FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /build

# Copy pom.xml
COPY pom.xml .

# Download dependencies
RUN apk add --no-cache maven && \
    mvn dependency:resolve

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Extract JAR layers for optimization
RUN java -Djarmode=layertools -jar target/task-manager-api-*.jar extract

# Final stage
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Create logs directory
RUN mkdir -p /app/logs

# Copy layers from builder
COPY --from=builder /build/dependencies/ ./
COPY --from=builder /build/spring-boot-loader/ ./
COPY --from=builder /build/snapshot-dependencies/ ./
COPY --from=builder /build/application/ ./

EXPOSE 8080

# Health check
HEALTHCHECK --interval=10s --timeout=5s --retries=3 --start-period=20s \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
