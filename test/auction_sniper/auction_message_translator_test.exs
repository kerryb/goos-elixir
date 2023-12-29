defmodule AuctionSniper.AuctionMessageTranslatorTest do
  use ExUnit.Case, async: true

  alias AuctionSniper.AuctionMessageTranslator
  alias Romeo.Stanza.Message

  test "notifies bid details when current price message received" do
    message = %Message{body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;"}
    AuctionMessageTranslator.process_message(message)
    assert_receive {:current_price, 192, 7}
  end

  test "notifies auction closed when close message received" do
    message = %Message{body: "SOLVersion: 1.1; Event: CLOSE;"}
    AuctionMessageTranslator.process_message(message)
    assert_receive :auction_closed
  end
end
