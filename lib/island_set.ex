defmodule IslandsEngine.IslandSet do
  alias IslandsEngine.{Island, IslandSet}

  defstruct atoll: :none, dot: :none, l_shape: :none, s_shape: :none, sqaure: :none

  defp keys() do
    %IslandSet{}
    |> Map.from_struct
    |> Map.keys
  end

  defp initialized_set() do
    Enum.reduce(keys(), %{}, fn key, set ->
      {:ok, island} = Island.start_link()
      Map.put_new(set, key, island)
    end)
  end

  def start_link() do
    Agent.start_link(fn -> initialized_set() end)
  end

  defp string_body(island_set) do
    Enum.reduce(keys(), "", fn key, acc ->
      island = Agent.get(island_set, &(Map.fetch!(&1, key)))
      acc <> "#{key} =>" <> Island.to_string(island) <> "\n"
    end)
  end

  def to_string(island_set) do
    "%IslandSet{" <> string_body(island_set) <> "}"
  end
end
