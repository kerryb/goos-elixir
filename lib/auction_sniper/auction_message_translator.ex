defmodule AuctionSniper.AuctionMessageTranslator do
  @moduledoc false

  def process_message(_message) do
    send(self(), :auction_closed)
  end
end
