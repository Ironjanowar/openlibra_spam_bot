defmodule OpenlibraSpamBot do
  use Application
  def start, do: start(1, 1)

  require Logger

  def start(_, _) do
    import Supervisor.Spec

    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(OpenlibraSpamBot.Bot, [:polling, token])
    ]

    opts = [strategy: :one_for_one, name: OpenlibraSpamBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting OpenlibraSpamBot")
        formats = ExGram.Config.get(:openlibra_spam_bot, :formats) |> String.replace(":", ", ")
        channel = ExGram.Config.get(:openlibra_spam_bot, :channel)
        Logger.info("Channel: #{channel}")
        Logger.info("Formats: #{formats}")
        ok

      error ->
        Logger.error("Error starting OpenlibraSpamBot")
        error
    end
  end
end
