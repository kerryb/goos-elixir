defmodule AuctionSniper.AuctionMessageTranslator do
  @moduledoc false

  def process_message(message) do
    event = unpack_event_from(message)

    case event["Event"] do
      "PRICE" ->
        send(self(), {:current_price, String.to_integer(event["CurrentPrice"]), String.to_integer(event["Increment"])})

      "CLOSE" ->
        send(self(), :auction_closed)
    end
  end

  defp unpack_event_from(message) do
    message.body
    |> String.split(";", trim: true)
    |> Map.new(fn element ->
      element |> String.split(":") |> Enum.map(&String.trim/1) |> List.to_tuple()
    end)
  end
end
