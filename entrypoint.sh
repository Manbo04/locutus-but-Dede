#!/bin/bash

# Create config directory if it doesn't exist
mkdir -p config

# Trim whitespace from environment variables
BOT_TOKEN=$(echo "$BOT_TOKEN" | tr -d '[:space:]')
API_KEY_PRIMARY=$(echo "$API_KEY_PRIMARY" | tr -d '[:space:]')

# Always recreate config to pick up latest env vars
echo "Creating config/config.yaml from Railway variables..."
cat > config/config.yaml << EOF
BOT_TOKEN: "${BOT_TOKEN}"
APPLICATION_ID: ${APPLICATION_ID}
API_KEY_PRIMARY: "${API_KEY_PRIMARY}"
ROOT_SERVER: ${ROOT_SERVER}
EOF

echo "Config created:"
cat config/config.yaml

# Start the bot
exec java -jar bot.jar