# Use the Eclipse Temurin 17 JDK image as the build stage
FROM eclipse-temurin:17-jdk AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven wrapper files and the pom.xml
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Install Maven dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Package the application
RUN ./mvnw package -DskipTests

# Use the Eclipse Temurin JDK image as the final image
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Install bash on Alpine
RUN apk update && apk add bash

# Create a user for Jenkins with a valid shell path
RUN useradd -m -u 1000 -s /bin/bash jenkin

# Copy the JAR file from the build stage
COPY --from=build /app/target/springboot-cicd-1.0.0.jar /springboot-cicd-1.0.0.jar

# Expose the port the application will run on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/springboot_cicd_1-0.0.1-SNAPSHOT.jar"]
