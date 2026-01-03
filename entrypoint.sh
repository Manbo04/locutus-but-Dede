#!/bin/bash

# Create config directory if it doesn't exist
mkdir -p config

# Always recreate config to pick up latest env vars
echo "Creating config/config.yaml from Railway variables..."
cat > config/config.yaml << EOF
token: "${DISCORD_TOKEN}"
ownerId: ${OWNER_ID}
apiKey: "${PNW_KEY}"
ROOT_SERVER: ${ROOT_SERVER}
EOF

echo "Config created with ROOT_SERVER: ${ROOT_SERVER}"

# Start the bot
exec java -jar bot.jar