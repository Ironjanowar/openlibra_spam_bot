# It is taken from the environment, or "dev" by default
MIX_ENV ?= dev

compile:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get
	mix compile

run: export BOT_TOKEN = $(shell cat bot.token)
run: export TELEGRAM_CHANNEL = @theIronChannel
run: export FILE_FORMATS = pdf:epub:mobi:azw:azw3:djvu:tex
run: compile
	mix run --no-halt

clean:
	rm -rf _build

.PHONY: compile run clean
