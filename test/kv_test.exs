defmodule KVTest do
  use ExUnit.Case
  doctest KV

  test "can create table" do
    assert KV.add_table(:test) == :ok
  end

  test "can add key-value" do
    KV.add_table(:test)
    assert KV.put("test", "id_12345", :test) == :ok
  end

  test "can get saved value" do
    id = "id_12345"
    KV.add_table(:test)
    KV.put("test", id, :test)
    assert KV.get(id, :test) == {:ok, "test"}
  end

  test "can overwrite saved key-value" do
    id = "id_12345"
    KV.add_table(:test)
    KV.put("test", id, :test)
    assert KV.put("test_1", id, :test) == :ok
    assert KV.get(id, :test) == {:ok, "test_1"}
  end

  test "can delete saved key-value" do
    id = "id_12345"
    KV.add_table(:test)
    KV.put("test", id, :test)
    assert KV.delete(id, :test) == :ok
    assert KV.get(id, :test) == {:ok, nil}
  end
end
