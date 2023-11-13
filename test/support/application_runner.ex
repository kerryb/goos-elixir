defmodule AuctionSniper.ApplicationRunner do
  alias AuctionSniper.AuctionSniperDriver

  @sniper_id "sniper"
  @sniper_password "sniper"

  @status_joining "Joining"

  def start_bidding_in(auction) do
    main_viewport_config = Application.get_env(:auction_sniper, :viewport)

    children = [
      {Scenic, [main_viewport_config]},
      AuctionSniper.PubSub.Supervisor
    ]

    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
    AuctionSniperDriver.shows_sniper_status(pid, @status_joining)
    {:ok, pid}
  end

  def has_received_join_request_from_sniper(_application, _auction) do
  end

  def shows_sniper_has_lost_auction(_application) do
  end
end
