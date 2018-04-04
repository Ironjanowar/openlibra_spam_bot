# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :openlibra_spam_bot,
  token: {:system, "BOT_TOKEN"},
  channel: {:system, "TELEGRAM_CHANNEL"},
  formats: {:system, "FILE_FORMATS"}
