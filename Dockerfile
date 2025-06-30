FROM maven:3.9.6-eclipse-temurin-17 as builder

# Set working directory inside the container
WORKDIR /app

# Copy Maven project files
COPY . .

# Install dependencies and run tests (this will fail if tests fail)
RUN apt-get update && apt-get install -y wget gnupg curl unzip \
 && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
 && apt-get update && apt-get install -y google-chrome-stable \
 && mvn clean package -DskipTests=false

# Final image
FROM openjdk:17-jdk-slim

# Install Chrome again (needed for runtime if your app needs it)
RUN apt-get update && apt-get install -y wget gnupg curl unzip \
 && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
 && apt-get update && apt-get install -y google-chrome-stable

# Set workdir
WORKDIR /app

# Copy compiled JAR from builder
COPY --from=builder /app/target/healenium-selenium-maven-example-1.0-SNAPSHOT.jar app.jar

# Default command
ENTRYPOINT ["java", "-jar", "app.jar"]
