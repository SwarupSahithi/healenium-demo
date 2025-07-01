# -------- Stage 1: Build and Run Tests --------
FROM maven:3.9.6-eclipse-temurin-8 as builder

# Install Chrome & dependencies
RUN
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Run tests with Maven (you can add `-Dtest=YourTest` to run specific test)
RUN mvn clean test

# -------- Stage 2: Minimal image with results (optional) --------
# FROM openjdk:8-jre-slim
# COPY --from=builder /app/target /app/target
# WORKDIR /app
# CMD ["sh", "-c", "echo 'Copy reports from /app/target'" ]
