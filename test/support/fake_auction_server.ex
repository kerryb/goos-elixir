defmodule AuctionSniper.FakeAuctionServer do
  @moduledoc false
  use GenServer

  import ExUnit.Assertions

  def start_link(item_id) do
    GenServer.start_link(__MODULE__, item_id)
  end

  @impl GenServer
  def init(item_id) do
    {:ok, %{item_id: item_id}}
  end

  def item_id(pid) do
    GenServer.call(pid, :item_id)
  end

  def start_selling_item(_auction) do
  end

  def announce_closed(_auction) do
  end

  def has_received_join_request_from_sniper(_auction) do
    flunk("TODO")
  end

  @impl GenServer
  def handle_call(:item_id, _from, state) do
    {:reply, state.item_id, state}
  end
end
