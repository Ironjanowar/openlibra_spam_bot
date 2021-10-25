defmodule OpenlibraSpamBot.Utils do
  alias OpenlibraSpamBot.DocumentCache

  def generate_forward_question(message_id, document, target) do
    formatted_target = Enum.join(target, ", ")
    message = "Quieres reenviar este archivo a: #{formatted_target}?"

    markup =
      ExGram.Dsl.create_inline([
        [
          [text: "Si", callback_data: "forward:yes:#{message_id}"],
          [text: "No", callback_data: "forward:no"]
        ]
      ])

    DocumentCache.cache_document(message_id, document)

    {message, markup}
  end

  defp format_line(""), do: " <b>None! HA!</b>"
  defp format_line("." <> _ = format), do: "  - #{format}"
  defp format_line(format), do: " - .#{format}"

  defp remove_point("." <> meh), do: meh
  defp remove_point(meh), do: meh

  # Yep...
  defp format_formats(formats), do: formats |> String.split(":") |> Enum.map(&String.trim/1)

  def get_raw_formats() do
    ExGram.Config.get(:openlibra_spam_bot, :formats, "")
    |> format_formats()
    |> Enum.map(&remove_point/1)
  end

  def get_formats() do
    formats =
      get_raw_formats()
      |> Enum.map(&format_line/1)
      |> Enum.join("\n")

    case formats do
      "" ->
        "No formats specified, I would not forward any files.\nPlease contact the bot administrator"

      formats ->
        "<i>This are the current formats that I admit:</i>\n<code>#{formats}</code>"
    end
  end

  def is_valid_format?(file_name) do
    format =
      file_name
      |> String.split(".")
      |> Enum.reverse()
      |> (fn [h | _] -> h end).()

    format in get_raw_formats()
  end

  def get_channels() do
    ExGram.Config.get(:openlibra_spam_bot, :channels, "@theIronChannel")
    |> String.split(":")
    |> Enum.map(&String.trim/1)
  end
end
