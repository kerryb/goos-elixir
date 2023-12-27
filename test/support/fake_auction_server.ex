defmodule AuctionSniper.FakeAuctionServer do
  @moduledoc false
  use GenServer

  import ExUnit.Assertions

  alias Romeo.Connection
  alias Romeo.Stanza

  @xmpp_hostname "localhost"
  @auction_password "auction"

  # Client

  def start_link(item_id) do
    GenServer.start_link(__MODULE__, item_id)
  end

  def item_id(pid) do
    GenServer.call(pid, :item_id)
  end

  def start_selling_item(pid) do
    GenServer.cast(pid, :start_selling_item)
  end

  def report_price(pid, price, increment, bidder) do
    GenServer.cast(pid, {:report_price, price, increment, bidder})
  end

  def announce_closed(pid) do
    GenServer.cast(pid, :announce_closed)
  end

  def has_received_join_request_from_sniper(pid, timeout \\ System.monotonic_time(:millisecond) + 5000) do
    case GenServer.call(pid, {:has_received_a_message, &any_message/1}) do
      :ok ->
        :ok

      {:error, message} ->
        if System.monotonic_time(:millisecond) > timeout do
          flunk(message)
        else
          Process.sleep(10)
          has_received_join_request_from_sniper(pid, timeout)
        end
    end
  end

  def has_received_bid(_auction, _bid, _sniper_id) do
    raise "TODO"
  end

  # Server

  @impl GenServer
  def init(item_id) do
    {:ok, %{item_id: item_id, connection_pid: nil, sniper_user_id: nil, received_messages: []}}
  end

  @impl GenServer
  def handle_call(:item_id, _from, state) do
    {:reply, state.item_id, state}
  end

  def handle_call({:has_received_a_message, matcher}, _from, state) do
    if Enum.any?(state.received_messages, matcher) do
      {:reply, :ok, state}
    else
      {:reply, {:error, "No messages in #{inspect(state.received_messages)} matched"}, state}
    end
  end

  @impl GenServer
  def handle_cast(:start_selling_item, state) do
    {:ok, connection_pid} =
      Connection.start_link(
        jid: jid(item_id_as_login(state.item_id), @xmpp_hostname),
        password: @auction_password,
        ssl_opts: [verify: :verify_none]
      )

    Connection.send(connection_pid, Stanza.presence())

    {:noreply, %{state | connection_pid: connection_pid}}
  end

  def handle_cast({:report_price, price, increment, bidder}, state) do
    :ok =
      Connection.send(
        state.connection_pid,
        Stanza.message(
          jid(state.sniper_user_id, @xmpp_hostname),
          "chat",
          "SOLVersion: 1.1; Event: PRICE; CurrentPrice: #{price}; Increment: #{increment}; Bidder: #{bidder}"
        )
      )

    {:noreply, state}
  end

  def handle_cast(:announce_closed, state) do
    :ok = Connection.send(state.connection_pid, Stanza.message(jid(state.sniper_user_id, @xmpp_hostname), "chat", ""))
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:stanza, %{type: "chat"} = message}, state) do
    {:noreply,
     state |> Map.put(:sniper_user_id, message.from.user) |> Map.update!(:received_messages, &[message.body | &1])}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  # Private

  defp item_id_as_login(item_id) do
    "auction-#{item_id}"
  end

  defp jid(login, hostname) do
    "#{login}@#{hostname}"
  end

  defp any_message(_message), do: true
end
