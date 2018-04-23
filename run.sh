#!/usr/bin/env bash

export BOT_TOKEN=$(cat bot.token)

echo "Getting deps"
mix deps.get

echo "Installing make"
apk add make # Dependency needed and not in alpine image

echo "Compiling..."
mix compile

echo "Running..."
mix run --no-halt
