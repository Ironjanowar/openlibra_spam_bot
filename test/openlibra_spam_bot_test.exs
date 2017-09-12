defmodule OpenlibraSpamBotTest do
  use ExUnit.Case
  doctest OpenlibraSpamBot

  test "greets the world" do
    assert OpenlibraSpamBot.hello() == :world
  end
end
