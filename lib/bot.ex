defmodule OpenlibraSpamBot.Bot do
  @bot :openlibra_spam_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  alias OpenlibraSpamBot.DocumentCache

  @channels OpenlibraSpamBot.Utils.get_channels()

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
      {message, markup} = OpenlibraSpamBot.Utils.generate_forward_question(mid, doc, @channels)
      answer(context, message, reply_markup: markup, reply_to_message_id: mid)
    else
      Logger.info("#{file_name}[#{doc}] doesn't have a valid format")
    end
  end

  def handle(
        {:callback_query, %{data: "forward:yes:" <> message_id, message: %{message_id: mid}}},
        context
      ) do
    formatted_channels = Enum.join(@channels, ", ")

    with {integer_message_id, _} <- Integer.parse(message_id),
         doc when not is_nil(doc) <- DocumentCache.get_document(integer_message_id),
         {:ok, _} = ok <- send_document(@channels, doc) do
      Logger.info("Forwarding document with ID: #{doc}")
      ok |> inspect |> Logger.debug()

      edit(context, :inline, "Archivo reenviado a: #{formatted_channels}",
        reply_to_message_id: mid
      )
    else
      error ->
        error |> inspect |> Logger.debug()

        edit(
          context,
          :inline,
          "Ha habido un error reenviando el archivo a: #{formatted_channels}",
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

  defp send_document(channels, doc) do
    result =
      Enum.map(channels, fn channel ->
        case ExGram.send_document(channel, doc) do
          {:ok, _} -> :ok
          error -> error
        end
      end)
      |> Enum.reject(&(&1 == :ok))

    if result == [] do
      :ok
    else
      result
    end
  end
end
