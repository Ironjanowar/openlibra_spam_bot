defmodule OpenlibraSpamBot.Bot do
  @bot :openlibra_spam_bot
  def bot(), do: @bot

  use Telex.Bot, name: @bot
  use Telex.Dsl

  @channel Telex.Config.get(@bot, :channel, "@theIronChannel")

  require Logger

  def handle({:command, "start", msg}, name, _) do
    answer msg, "Helloooo", bot: name
  end

  def handle({:command, "formats", msg}, name, _) do
    answer msg, OpenlibraSpamBot.Utils.get_formats, bot: name, parse_mode: "HTML"
  end

  def handle({:message, %{document: %{file_id: doc}, message_id: mid} = msg}, name, _) do
    Logger.info "Document found with ID: #{doc}"
    {message, markup} = OpenlibraSpamBot.Utils.generate_forward_question(doc)
    answer msg, message, bot: name, reply_markup: markup, reply_to_message_id: mid
  end

  def handle({:callback_query, %{data: "forward:yes:" <> doc, message: %{message_id: mid}} = msg}, name, _) do
    Logger.info "Forwarding document"
    Telex.send_document @channel, doc, bot: name

    edit :inline, msg, "Archivo reenviado a #{@channel}", bot: name, reply_to_message_id: mid
  end

  def handle({:callback_query, %{data: "forward:no", message: %{message_id: mid}} = msg}, name, _) do
    Logger.info "Not forwarding"
    edit :inline, msg, "El archivo no se reenviará", bot: name, reply_to_message_id: mid
  end
end
