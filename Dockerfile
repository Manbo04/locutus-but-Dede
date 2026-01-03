# Stage 1: Build stage
FROM eclipse-temurin:22-jdk-jammy AS builder

WORKDIR /build

# Copy gradle files and source code
COPY gradlew .
COPY gradlew.bat .
COPY gradle/ gradle/
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties .
COPY src/ src/

# Make gradlew executable
RUN chmod +x gradlew

# Build the shadow JAR (skip tests and graphql codegen)
RUN ./gradlew shadowJar --no-daemon -x test -x graphqlCodegenProductService

# Stage 2: Runtime stage
FROM eclipse-temurin:22-jre-jammy

WORKDIR /app

# --- FIX 1: Use a wildcard (*) to grab the jar whatever it is named ---
COPY --from=builder /build/build/libs/*.jar bot.jar

# --- FIX 2: Copy the script we are about to make ---
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# --- FIX 3: Run the script instead of Java directly ---
ENTRYPOINT ["./entrypoint.sh"]