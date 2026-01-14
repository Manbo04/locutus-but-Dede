#!/bin/bash

# Create config directory if it doesn't exist
mkdir -p config
mkdir -p "${DATABASE_SQLITE_DIRECTORY:-/data/locutus}"

# Trim whitespace from environment variables
BOT_TOKEN=$(echo "$BOT_TOKEN" | tr -d '[:space:]')
API_KEY_PRIMARY=$(echo "$API_KEY_PRIMARY" | tr -d '[:space:]')
USERNAME=$(echo "$USERNAME" | tr -d '[:space:]')
PASSWORD=$(echo "$PASSWORD" | tr -d '[:space:]')
ACCESS_KEY=$(echo "$ACCESS_KEY" | tr -d '[:space:]')

# Generate a random conversion secret if not provided
if [ -z "$CONVERSION_SECRET" ]; then
    CONVERSION_SECRET=$(openssl rand -hex 16)
fi

# Always recreate config to pick up latest env vars
echo "Creating config/config.yaml from Railway variables..."
cat > config/config.yaml << EOF
# Locutus Discord Bot Configuration
TEST: false

# Required: Discord Bot Token
BOT_TOKEN: "${BOT_TOKEN}"

# Required: Discord Application ID
APPLICATION_ID: ${APPLICATION_ID}

# Required: Root server (management guild) ID
ROOT_SERVER: ${ROOT_SERVER}

# Optional: Root coalition server ID (defaults to ROOT_SERVER)
ROOT_COALITION_SERVER: ${ROOT_COALITION_SERVER:-0}

# Optional: Forum feed server ID (set to 0 to disable)
FORUM_FEED_SERVER: ${FORUM_FEED_SERVER:-0}

# Optional: Politics & War Credentials (recommended for full functionality)
USERNAME: "${USERNAME}"
PASSWORD: "${PASSWORD}"

# Required: Politics & War API Key
API_KEY_PRIMARY: "${API_KEY_PRIMARY}"

# Optional: P&W verified bot key (for banking/ingame actions)
ACCESS_KEY: "${ACCESS_KEY}"

# Database configuration (SQLite only)
DATABASE:
  SQLITE:
    USE: true
    DIRECTORY: "${DATABASE_SQLITE_DIRECTORY:-/data/locutus}"

# Optional: Support server invite code
SUPPORT_INVITE: "cUuskPDrB7"

# Generated: Bank transfer conversion secret
CONVERSION_SECRET: "${CONVERSION_SECRET}"

# Number of Discord shards (only change if bot is in 2500+ servers)
SHARDS: 1

# Enabled components - configure as needed
ENABLED_COMPONENTS:
  USE_API: true
  DISCORD_BOT: true
  MESSAGE_COMMANDS: true
  SLASH_COMMANDS: true
  REGISTER_ADMIN_SLASH_COMMANDS: true
  WEB: true
  REPEATING_TASKS: true
  SUBSCRIPTIONS: true
  EVENTS: true
  PROXY: false
  SNAPSHOTS: true

# Web interface configuration
WEB:
  PORT: 3000
  ENABLE_SSL: false
EOF

echo "Config created:"
cat config/config.yaml

# Start the bot
exec java -jar bot.jar