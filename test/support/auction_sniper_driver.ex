defmodule AuctionSniper.AuctionSniperDriver do
  @moduledoc false

  import ExUnit.Assertions

  def shows_sniper_status(status_text) do
    :main_viewport
    |> Process.whereis()
    |> :sys.get_state()
    |> Map.get(:script_table)
    |> wait_for_status(status_text, System.monotonic_time(:millisecond) + 5000)
  end

  defp wait_for_status(script_table, status_text, timeout) do
    graph = get_graph(script_table)
    {_, text} = Enum.find(graph, &match?({:draw_text, _}, &1))

    cond do
      text == status_text ->
        :ok

      System.monotonic_time(:millisecond) > timeout ->
        flunk("Expected status to show #{inspect(status_text)}, but got #{inspect(text)}")

      true ->
        Process.sleep(10)
        wait_for_status(script_table, status_text, timeout)
    end
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
