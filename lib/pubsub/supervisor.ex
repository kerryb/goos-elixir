# a simple supervisor that starts up the Scenic.SensorPubSub server
# and any set of other sensor processes

defmodule AuctionSniper.PubSub.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
    # add your data publishers here
  end
end
