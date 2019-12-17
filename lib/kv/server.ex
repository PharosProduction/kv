defmodule KV.Server do
  use GenServer
  require Logger

  alias :ets, as: Ets

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def add_table(name) do
    GenServer.cast(__MODULE__, {:add_table, name, :set})
  end

  def add_table(name, :set) do
    GenServer.cast(__MODULE__, {:add_table, name, :set})
  end

  def add_table(name, :bag) do
    GenServer.cast(__MODULE__, {:add_table, name, :bag})
  end

  def put(value, key, table_name) do
    GenServer.cast(__MODULE__, {:put, value, key, table_name})
  end

  def get(key, table_name, default) do
    GenServer.call(__MODULE__, {:get, key, table_name, default})
  end

  def delete(key, table_name) do
    GenServer.cast(__MODULE__, {:delete, key, table_name})
  end

  # Server
  @impl true
  def init(_opts) do
    Logger.debug("#{inspect(__MODULE__)} initialized")

    {:ok, nil}
  end

  @impl true
  def handle_call({:get, key, table_name, default}, _from, state) do
    with [{_key, value}] <- Ets.lookup(table_name, key) do
      {:reply, {:ok, value}, state}
    else
      [] -> {:reply, {:ok, default}, state}
      [_head | _tail] -> {:reply, {:error, :corrupted}, state}
    end
  end

  @impl true
  def handle_cast({:add_table, name, type}, state) do
    try do
      Ets.new(name, [type, :protected, :named_table])
      {:noreply, state}
    rescue
      ArgumentError -> {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:put, value, key, table_name}, state) do
    Ets.delete(table_name, key)
    Ets.insert_new(table_name, {key, value})

    {:noreply, state}
  end

  @impl true
  def handle_cast({:delete, key, table_name}, state) do
    Ets.delete(table_name, key)

    {:noreply, state}
  end
end
