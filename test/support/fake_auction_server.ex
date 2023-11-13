defmodule AuctionSniper.FakeAuctionServer do
  @moduledoc false
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_selling_item(_auction) do
  end

  def announce_closed(_auction) do
  end

  def has_received_join_request_from_sniper(_auction) do
  end
end
