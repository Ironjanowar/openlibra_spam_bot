defmodule OpenlibraSpamBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :openlibra_spam_bot,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OpenlibraSpamBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.10"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      {:jason, ">= 1.0.0"},
      {:logger_file_backend, "0.0.11"}
    ]
  end
end
