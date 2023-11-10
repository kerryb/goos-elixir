defmodule AuctionSniper.EndToEndTest do
  use ExUnit.Case, async: true

  describe "AuctionSniper end-to-end" do
    setup do
      {:ok, auction} = start_supervised(FakeAuctionServer, "item-54321")
      {:ok, application} = start_supervised(ApplicationRunner)
      %{auction: auction, application: application}
    end

    test "sniper joins auction until auction closes", %{
      auction: auction,
      application: application
    } do
      FakeAuctionServer.start_selling_item(auction)
      ApplicationRunner.start_bidding_in(application, auction)
      FakeAuctionServer.has_received_join_request_from_sniper(auction)
      FakeAuctionServer.shows_sniper_has_lost_auction(auction)
      ApplicationRunner.shows_sniper_has_lost_auction(application)
    end
  end
end
