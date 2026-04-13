# ----------- Stage 1: Build -----------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom first (for caching dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build jar
RUN mvn clean package -DskipTests


# ----------- Stage 2: Run -----------
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"] 
