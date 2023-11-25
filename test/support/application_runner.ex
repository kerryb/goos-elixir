defmodule AuctionSniper.ApplicationRunner do
  @moduledoc false
  import ExUnit.Assertions

  alias AuctionSniper.AuctionSniperDriver

  @sniper_id "sniper"
  @sniper_password "sniper"

  @status_joining "Joining"

  def start_bidding_in(auction) do
    {:ok, _pid} = AuctionSniper.start(:temporary, [@sniper_id, @sniper_password])
    AuctionSniperDriver.shows_sniper_status(@status_joining)
  end

  def has_received_join_request_from_sniper(_auction) do
    flunk("TODO")
  end

  def shows_sniper_has_lost_auction do
    flunk("TODO")
  end
end
