defmodule OpenlibraSpamBot.Utils do
  def generate_forward_question(document, target \\ "@openlibra_channel") do
    message = "Quieres reenviar este archivo a #{target}?"
    markup = Telex.Dsl.create_inline([[[text: "Si", callback_data: "forward:yes:#{document}"], [text: "No", callback_data: "forward:no"]]])

    {message, markup}
  end

  def forward_document(doc, name, target \\ "@theIronChannel") do
    Telex.send_document target, doc, bot: name
  end
end
