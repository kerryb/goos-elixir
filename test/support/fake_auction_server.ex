defmodule AuctionSniper.FakeAuctionServer do
  @moduledoc false
  use GenServer

  import ExUnit.Assertions

  alias Romeo.Connection

  @xmpp_hostname "localhost"
  @auction_password "auction"

  def start_link(item_id) do
    GenServer.start_link(__MODULE__, item_id)
  end

  @impl GenServer
  def init(item_id) do
    {:ok, %{item_id: item_id, connection_pid: nil}}
  end

  def item_id(pid) do
    GenServer.call(pid, :item_id)
  end

  def start_selling_item(pid) do
    GenServer.call(pid, :start_selling_item)
  end

  def announce_closed(_auction) do
  end

  def has_received_join_request_from_sniper(_auction) do
    flunk("TODO")
  end

  @impl GenServer
  def handle_call(:item_id, _from, state) do
    {:reply, state.item_id, state}
  end

  def handle_call(:start_selling_item, _from, state) do
    {:ok, connection_pid} =
      Connection.start_link(
        jid: jid(item_id_as_login(state.item_id), @xmpp_hostname),
        password: @auction_password,
        ssl_opts: [verify: :verify_none]
      )

    {:reply, state.item_id, %{state | connection_pid: connection_pid}}
  end

  defp item_id_as_login(item_id) do
    "auction-#{item_id}"
  end

  defp jid(login, hostname) do
    "#{login}@#{hostname}"
  end
end
