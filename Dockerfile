# Stage 1: Build stage
FROM eclipse-temurin:22-jdk-jammy AS builder

WORKDIR /build

COPY gradlew .
COPY gradlew.bat .
COPY gradle/ gradle/
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties .
COPY src/ src/

# --- HARDCODED KEY FIX ---
# We are pasting the key directly here to bypass the Railway UI issue.
ENV PNW_KEY=28b5d27d6a88e91d5408
ENV apiKey=28b5d27d6a88e91d5408

# Create config files manually so the builder finds them
RUN echo "apiKey: 28b5d27d6a88e91d5408" > bot_config.json && \
    echo "pnwKey: 28b5d27d6a88e91d5408" >> bot_config.json && \
    echo "apiKey: 28b5d27d6a88e91d5408" > config.yml && \
    echo "pnwKey: 28b5d27d6a88e91d5408" >> config.yml

    # Build the shadow JAR (skip tests which require database, disable config cache for GraphQL codegen)
    RUN chmod +x gradlew && ./gradlew shadowJar --no-daemon --no-configuration-cache -x test# Stage 2: Runtime stage
FROM eclipse-temurin:22-jre-jammy

WORKDIR /app

COPY --from=builder /build/build/libs/*.jar bot.jar
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Create data directory
RUN mkdir -p /app/data

# --- FIX 3: Run the script instead of Java directly ---
ENTRYPOINT ["./entrypoint.sh"]