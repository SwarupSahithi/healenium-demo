# -------- Stage 1: Build and run tests --------
FROM maven:3.9.6-eclipse-temurin-8 AS builder

WORKDIR /app

# Copy project files
COPY . .

# Run Maven tests and generate reports
RUN mvn clean test

# -------- Stage 2: Export results (optional) --------
# If you want to keep the image lightweight or extract results separately
# you can skip this and run directly from stage 1
