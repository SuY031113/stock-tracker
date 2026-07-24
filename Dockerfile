# Stage 1: build the JAR
# TODO 1: Start FROM the maven:3.9-eclipse-temurin-21 image. Name this stage 'build'.
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# TODO 2: Copy pom.xml into the working directory
COPY pom.xml .

# TODO 3: Download all dependencies into the image layer cache
#         Hint: mvn dependency:go-offline -q
RUN mvn dependency:go-offline -q

# TODO 4: Copy the src directory into the image
COPY src ./src

# TODO 5: Package the application, skipping tests
#         Hint: mvn package -DskipTests -q
RUN mvn package -DskipTests -q

# Stage 2: run the JAR in a minimal image
# TODO 6: Start FROM eclipse-temurin:21-jre-alpine
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# TODO 7: Copy the JAR from the build stage into this image as app.jar
#         Hint: use --from=build and /app/target/*.jar
COPY --from=build /app/target/*.jar app.jar

# TODO 8: Tell Docker which port the app listens on
EXPOSE 8080

# TODO 9: Set the command to run the JAR
#         Hint: ENTRYPOINT with JSON array syntax
ENTRYPOINT ["java", "-jar", "app.jar"]

