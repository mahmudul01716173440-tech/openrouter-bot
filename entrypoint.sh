#!/bin/sh

echo "API_KEY=$API_KEY" > .env
echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" >> .env
echo "MODEL=$MODEL" >> .env
echo "ADMIN_IDS=$ADMIN_IDS" >> .env
echo "ALLOWED_USER_IDS=$ALLOWED_USER_IDS" >> .env
echo "GUEST_BUDGET=$GUEST_BUDGET" >> .env
echo "MAX_TOKENS=$MAX_TOKENS" >> .env
echo "TEMPERATURE=$TEMPERATURE" >> .env
echo "TOP_P=$TOP_P" >> .env
echo "TOP_K=$TOP_K" >> .env
echo "REPETITION_PENALTY=$REPETITION_PENALTY" >> .env
echo "LANG=${LANG:-EN}" >> .env

exec ./openrouter-bot
