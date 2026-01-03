#!/bin/bash
if [ ! -f config.yml ]; then
    echo "Creating config.yml from Railway variables..."
    echo "token: \"$DISCORD_TOKEN\"" >> config.yml
    echo "ownerId: \"$OWNER_ID\"" >> config.yml
    echo "apiKey: \"$PNW_KEY\"" >> config.yml
fi

# Start the bot
exec java -jar bot.jar