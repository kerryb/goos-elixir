defmodule AuctionSniper.ApplicationRunner do
  @moduledoc false
  alias AuctionSniper.AuctionSniperDriver

  @sniper_id "sniper"
  @sniper_password "sniper"

  @status_joining "Joining"

  def start_bidding_in(auction) do
    {:ok, _pid} = Application.ensure_all_started(:auction_sniper)
    AuctionSniperDriver.shows_sniper_status(@status_joining)
  end

  def has_received_join_request_from_sniper(_application, _auction) do
  end

  def shows_sniper_has_lost_auction(_application) do
  end
end
