defmodule AuctionSniper.ApplicationRunner do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_bidding_in(_application, _auction) do
  end

  def has_received_join_request_from_sniper(_application, _auction) do
  end

  def shows_sniper_has_lost_auction(_application) do
  end
end
