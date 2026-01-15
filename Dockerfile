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
# Copy pre-generated jOOQ sources (committed to git, generated from SQLite schemas)
COPY build/generated-src/ build/generated-src/

# Config files are provided at runtime by entrypoint.sh using env vars; do not bake API keys into the image

# Remove references to missing _test.command package (private developer code not in public repo)
RUN sed -i '/_test\.command/d' src/main/java/link/locutus/discord/commands/manager/v2/impl/pw/refs/CM.java

# Build the shadow JAR (skip tests which require database, disable config cache for GraphQL codegen)
RUN chmod +x gradlew && ./gradlew shadowJar --no-daemon --no-configuration-cache -x test

# Stage 2: Runtime stage
FROM eclipse-temurin:22-jre-jammy

WORKDIR /app

COPY --from=builder /build/build/libs/*.jar bot.jar
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Create data directory
RUN mkdir -p /app/data

# --- FIX 3: Run the script instead of Java directly ---
ENTRYPOINT ["./entrypoint.sh"]