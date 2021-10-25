FROM bitwalker/alpine-elixir:1.6.4

ENV TELEGRAM_CHANNELS="@openlibra_channel"
ENV FILE_FORMATS="pdf:epub:mobi:azw:azw3:djvu:tex"

WORKDIR /app

ADD . /app

ENTRYPOINT ["/app/run.sh"]
