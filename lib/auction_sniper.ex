defmodule AuctionSniper do
  @moduledoc false
  use GenServer

  alias Romeo.Connection
  alias Romeo.Stanza

  # Client

  def start(_type, args) do
    main_viewport_config = Application.get_env(:auction_sniper, :viewport)

    children = [
      {Registry, keys: :unique, name: AuctionSniper.Registry},
      {Scenic, [main_viewport_config]},
      AuctionSniper.PubSub.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
    GenServer.start_link(__MODULE__, args)
  end

  # Server

  @impl GenServer
  def init([hostname, username, password, item_id]) do
    {:ok, connection_pid} =
      Connection.start_link(jid: jid(username, hostname), password: password, ssl_opts: [verify: :verify_none])

    :ok = Connection.send(connection_pid, Stanza.presence())
    :ok = Connection.send(connection_pid, Stanza.message(jid(auction_id(item_id), hostname), "chat", "Join"))
    {:ok, %{item_id: item_id, connection_pid: connection_pid}}
  end

  @impl GenServer
  def handle_info({:stanza, %{type: "chat"}}, state) do
    [{home_scene_pid, :pid}] = Registry.lookup(AuctionSniper.Registry, :home_scene)
    send(home_scene_pid, :lost)
    {:noreply, state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  # Private

  defp auction_id(item_id) do
    "auction-#{item_id}"
  end

  defp jid(login, hostname) do
    "#{login}@#{hostname}"
  end
end
