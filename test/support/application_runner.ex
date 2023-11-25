defmodule AuctionSniper.ApplicationRunner do
  @moduledoc false
  import ExUnit.Assertions

  alias AuctionSniper.AuctionSniperDriver
  alias AuctionSniper.FakeAuctionServer

  @xmpp_hostname "localhost"
  @sniper_id "sniper"
  @sniper_password "sniper"

  @status_joining "Joining"
  @status_lost "Lost"

  def start_bidding_in(auction) do
    {:ok, _sniper} =
      AuctionSniper.start(:temporary, [@xmpp_hostname, @sniper_id, @sniper_password, FakeAuctionServer.item_id(auction)])

    AuctionSniperDriver.shows_sniper_status(@status_joining)
  end

  def shows_sniper_has_lost_auction do
    AuctionSniperDriver.shows_sniper_status(@status_lost)
  end
end
