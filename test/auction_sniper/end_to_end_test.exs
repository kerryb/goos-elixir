defmodule AuctionSniper.EndToEndTest do
  use ExUnit.Case, async: true

  alias AuctionSniper.ApplicationRunner
  alias AuctionSniper.FakeAuctionServer

  describe "AuctionSniper end-to-end" do
    setup do
      {:ok, auction} = start_supervised({FakeAuctionServer, "item-54321"})
      %{auction: auction}
    end

    test "sniper joins auction until auction closes", %{auction: auction} do
      FakeAuctionServer.start_selling_item(auction)
      {:ok, application} = ApplicationRunner.start_bidding_in(auction)
      FakeAuctionServer.has_received_join_request_from_sniper(auction)
      FakeAuctionServer.announce_closed(auction)
      ApplicationRunner.shows_sniper_has_lost_auction(application)
    end
  end
end
