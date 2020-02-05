MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

token:
include .env
export $(shell sed 's/=.*//' .env)
export BOT_TOKEN = $(shell cat bot.token)

start: token
	_build/dev/rel/openlibra_spam_bot/bin/openlibra_spam_bot daemon

iex: token
	iex -S mix

clean:
	rm -rf _build

purge: clean
	rm -rf deps
	rm mix.lock

stop:
	_build/dev/rel/openlibra_spam_bot/bin/openlibra_spam_bot stop

attach:
	_build/dev/rel/openlibra_spam_bot/bin/openlibra_spam_bot remote

release: deps compile
	mix release

debug: token
	_build/dev/rel/openlibra_spam_bot/bin/openlibra_spam_bot console

error_logs:
	tail -n 20 -f log/error.log

debug_logs:
	tail -n 20 -f log/debug.log

.PHONY: deps compile release start clean purge token iex stop attach debug
