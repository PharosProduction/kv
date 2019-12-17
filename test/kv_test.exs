defmodule KVTest do
  use ExUnit.Case
  doctest KV

  @id "id_12345"

  setup do
    KV.add_table(:test)
    on_exit(fn -> KV.delete(@id, :test) end)
  end

  test "can add key-value" do
    assert KV.put("test", @id, :test) == :ok
  end

  test "can get saved value" do
    KV.put("test", @id, :test)
    assert KV.get(@id, :test) == {:ok, "test"}
  end

  test "can get with default" do
    assert KV.get(@id, :test, "test") == {:ok, "test"}
  end

  test "can overwrite saved key-value" do
    KV.put("test", @id, :test)
    assert KV.put("test_1", @id, :test) == :ok
    assert KV.get(@id, :test) == {:ok, "test_1"}
  end

  test "can delete saved key-value" do
    KV.put("test", @id, :test)
    assert KV.delete(@id, :test) == :ok
    assert KV.get(@id, :test) == {:ok, nil}
  end
end
