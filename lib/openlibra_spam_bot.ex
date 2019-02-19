defmodule OpenlibraSpamBot do
  use Application
  def start, do: start(1, 1)

  require Logger

  def start(_, _) do
    import Supervisor.Spec

    token = ExGram.Config.get(:openlibra_spam_bot, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(OpenlibraSpamBot.Bot, [:polling, token])
    ]

    opts = [strategy: :one_for_one, name: OpenlibraSpamBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting OpenlibraSpamBot")
        ok

      error ->
        Logger.error("Error starting OpenlibraSpamBot")
        error
    end
  end
end
