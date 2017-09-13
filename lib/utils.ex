defmodule OpenlibraSpamBot.Utils do
  def generate_forward_question(document, target \\ "@openlibra_channel") do
    message = "Quieres reenviar este archivo a #{target}?"
    markup = Telex.Dsl.create_inline([[[text: "Si", callback_data: "forward:yes:#{document}"], [text: "No", callback_data: "forward:no"]]])

    {message, markup}
  end

  defp format_line("." <> _ = format), do: "  - #{format}"
  defp format_line(format), do: " - .#{format}"

  def get_formats() do
    formats = Telex.Config.get(:openlibra_spam_bot, :formats, [])
    |> Enum.map(&format_line/1)
    |> Enum.join("\n")

    "<i>This are the current formats that I admit:</i>\n<code>#{formats}</code>"
  end
end
