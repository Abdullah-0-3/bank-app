# Stage 1 - Build Stage
FROM maven:3.8.3-openjdk-17 AS builder

LABEL maintainer="Abdullah Abrar <abdullahabrar4843@gmail.com>"
LABEL app="bank-app"

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests=true

# Stage 2 - Runtime Stage
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]