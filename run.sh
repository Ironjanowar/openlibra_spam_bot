#!/usr/bin/env bash

export BOT_TOKEN=$(cat bot.token)

echo "Getting deps"
mix deps.get
apk add make
echo "Compiling..."
mix compile

echo "Running..."
mix run --no-halt
