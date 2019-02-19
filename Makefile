# It is taken from the environment, or "dev" by default
MIX_ENV ?= dev

compile: _build/$(MIX_ENV)

run: export BOT_TOKEN = $(shell cat bot.token)
run: export TELEGRAM_CHANNEL = @theIronChannel
run: export FILE_FORMATS = pdf:epub
run: _build/$(MIX_ENV)
	mix run --no-halt

clean:
	rm -rf _build

.PHONY: compile run clean


## Not phony

_build/$(MIX_ENV):
	mix local.hex --force
	mix local.rebar --force
	mix deps.get
	mix compile
