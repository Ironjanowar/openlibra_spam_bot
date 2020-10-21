defmodule OpenlibraSpamBot.DocumentCache do
  use GenServer

  # Child specification
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: DocumentCache)
  end

  def cache_document(message_id, document) do
    GenServer.cast(DocumentCache, {:cache, message_id, document})
  end

  def get_document(message_id) do
    GenServer.call(DocumentCache, {:get, message_id})
  end

  # Server callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:get, message_id}, _from, cache) do
    {reply, new_cache} = Map.pop(cache, message_id)
    {:reply, reply, new_cache}
  end

  def handle_cast({:cache, message_id, document}, cache) do
    {:noreply, Map.put(cache, message_id, document)}
  end
end
