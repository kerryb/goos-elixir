defmodule AuctionSniper.AuctionSniperDriver do
  @moduledoc false

  import ExUnit.Assertions

  def shows_sniper_status(status_text) do
    script_table =
      :main_viewport
      |> Process.whereis()
      |> :sys.get_state()
      |> Map.get(:script_table)

    graph = get_graph(script_table)
    {_, text} = Enum.find(graph, &match?({:draw_text, _}, &1))
    assert text == status_text
  end

  defp get_graph(script_table, timeout \\ :timer.seconds(1))
  defp get_graph(_script_table, 0), do: raise("Status text not found")

  defp get_graph(script_table, timeout) do
    case :ets.lookup(script_table, "_main_") do
      [] ->
        Process.sleep(1)
        get_graph(script_table, timeout - 1)

      [{_id, graph, _pid}] ->
        graph
    end
  end
end
