# *********************************************************************
#                       Stage 1 - Development
# *********************************************************************

FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests=True

# *********************************************************************
#                       Stage 2 - Production
# *********************************************************************

FROM gcr.io/distroless/java17-debian12
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]