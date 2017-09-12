defmodule OpenlibraSpamBot.Bot do
  @bot :openlibra_spam_bot
  def bot(), do: @bot

  use Telex.Bot, name: @bot
  use Telex.Dsl

  @openlibra_channel "@openlibra_channel"

  require Logger

  def handle({:command, "start", msg}, name, _) do
    answer msg, "Helloooo", bot: name
  end

  def handle({_, _, %{document: %{file_id: doc}} = msg}, name, _) do
    Logger.info "Document found"
    {message, markup} = OpenlibraSpamBot.Utils.generate_forward_question(doc)
    answer msg, message, bot: name, reply_markup: markup
  end

  def handle({:command, "test", %{from: %{id: cid}, message_id: mid}=msg}, name, _) do
    # {message, markup} = OpenlibraSpamBot.Utils.generate_forward_question
    # answer msg, message, bot: name, reply_markup: markup, reply_to_message_id: mid

    Logger.info "Test received"

    Telex.send_message "@theIronChannel", "Helloooo testerino!", bot: name
  end

  def handle({:callback_query, %{message: %{chat: %{id: id}}, data: "forward:yes:" <> doc} = msg}, name, _) do
    Logger.info "Forwarding document"
    OpenlibraSpamBot.Utils.forward_document(doc, msg, name)

    edit :inline, "Archivo reenviado a #{@openlibra_channel}", bot: name
  end

  def handle({:callback_query, %{message: %{chat: %{id: id}}, data: "forward:no"} = msg}, name, _) do
    Logger.info "Not forwarding"
    edit :inline, "El archivo no se reenviará", bot: name
  end
end
