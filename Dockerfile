# Use an official Maven image to build the application
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application and run the tests
RUN mvn clean package

# Use a smaller image for runtime
FROM openjdk:11-jre-slim

# Set the working directory in the runtime container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/simple-java-app-1.0-SNAPSHOT.jar /app/app.jar

# Expose the application's port (if necessary)
# EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
