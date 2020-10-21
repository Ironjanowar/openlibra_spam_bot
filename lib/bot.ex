defmodule OpenlibraSpamBot.Bot do
  @bot :openlibra_spam_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  alias OpenlibraSpamBot.DocumentCache

  @channel ExGram.Config.get(@bot, :channel, "@theIronChannel")

  def bot(), do: @bot

  def handle({:command, "start", _msg}, context) do
    answer(context, "Helloooo")
  end

  def handle({:command, "formats", _msg}, context) do
    answer(context, OpenlibraSpamBot.Utils.get_formats(), parse_mode: "HTML")
  end

  def handle(
        {:message, %{document: %{file_id: doc, file_name: file_name}, message_id: mid}},
        context
      ) do
    Logger.info("Document found with ID: #{doc}")

    if OpenlibraSpamBot.Utils.is_valid_format?(file_name) do
      {message, markup} = OpenlibraSpamBot.Utils.generate_forward_question(mid, doc, @channel)
      answer(context, message, reply_markup: markup, reply_to_message_id: mid)
    else
      Logger.info("#{file_name}[#{doc}] doesn't have a valid format")
    end
  end

  def handle(
        {:callback_query, %{data: "forward:yes:" <> message_id, message: %{message_id: mid}}},
        context
      ) do
    with {integer_message_id, _} <- Integer.parse(message_id),
         doc when not is_nil(doc) <- DocumentCache.get_document(integer_message_id),
         {:ok, _} = ok <- ExGram.send_document(@channel, doc) do
      Logger.info("Forwarding document with ID: #{doc}")
      ok |> inspect |> Logger.debug()
      edit(context, :inline, "Archivo reenviado a #{@channel}", reply_to_message_id: mid)
    else
      error ->
        error |> inspect |> Logger.debug()

        edit(
          context,
          :inline,
          "Ha habido un error reenviando el archivo a #{@channel}",
          reply_to_message_id: mid
        )
    end
  end

  def handle(
        {:callback_query, %{data: "forward:no:" <> message_id, message: %{message_id: mid}}},
        context
      ) do
    Logger.info("Not forwarding")
    DocumentCache.get_document(message_id)
    edit(context, :inline, "El archivo no se reenviará", reply_to_message_id: mid)
  end

  def handle(_, _) do
    :unrecognized
  end
end
