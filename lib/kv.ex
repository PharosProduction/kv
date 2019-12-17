defmodule KV do
  @moduledoc """
  Documentation for KV.
  """

  defdelegate add_table(name), to: KV.Server
  defdelegate add_table(name, type), to: KV.Server
  defdelegate put(value, key, table_name), to: KV.Server
  defdelegate get(key, table_name, default \\ nil), to: KV.Server
  defdelegate delete(key, table_name), to: KV.Server
end
