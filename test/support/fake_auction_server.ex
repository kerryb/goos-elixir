defmodule AuctionSniper.FakeAuctionServer do
  @moduledoc false
  use GenServer

  import ExUnit.Assertions

  alias Romeo.Connection
  alias Romeo.Stanza

  @xmpp_hostname "localhost"
  @auction_password "auction"

  def start_link(item_id) do
    GenServer.start_link(__MODULE__, item_id)
  end

  @impl GenServer
  def init(item_id) do
    {:ok, %{item_id: item_id, connection_pid: nil, sniper_user_id: nil, wait_for_join_request_task_pid: nil}}
  end

  def item_id(pid) do
    GenServer.call(pid, :item_id)
  end

  def start_selling_item(pid) do
    GenServer.call(pid, :start_selling_item)
  end

  def announce_closed(pid) do
    GenServer.cast(pid, :announce_closed)
  end

  def has_received_join_request_from_sniper(pid) do
    task = Task.async(&wait_for_join_request/0)
    GenServer.cast(pid, {:wait_for_join_request, task.pid})

    if Task.await(task, :infinity) do
      :ok
    else
      flunk("Join message not received within five seconds")
    end
  end

  defp wait_for_join_request do
    receive do
      :join_request_received -> true
    after
      :timer.seconds(5) -> false
    end
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

    Connection.send(connection_pid, Stanza.presence())

    {:reply, state.item_id, %{state | connection_pid: connection_pid}}
  end

  defp item_id_as_login(item_id) do
    "auction-#{item_id}"
  end

  defp jid(login, hostname) do
    "#{login}@#{hostname}"
  end

  @impl GenServer
  def handle_cast({:wait_for_join_request, pid}, state) do
    if state.sniper_user_id do
      send(pid, :join_request_received)
      {:noreply, state}
    else
      {:noreply, %{state | wait_for_join_request_task_pid: pid}}
    end
  end

  def handle_cast(:announce_closed, state) do
    :ok = Connection.send(state.connection_pid, Stanza.message(jid(state.sniper_user_id, @xmpp_hostname), "chat", ""))
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:stanza, %{from: %{user: user}, type: "chat"}}, state) do
    if state.wait_for_join_request_task_pid do
      send(state.wait_for_join_request_task_pid, :join_request_received)
    end

    {:noreply, %{state | sniper_user_id: user}}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end
end
