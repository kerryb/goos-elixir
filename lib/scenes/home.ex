defmodule AuctionSniper.Scene.Home do
  @moduledoc false
  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph

  require Logger

  # import Scenic.Components

  @text_size 24

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    Registry.register(AuctionSniper.Registry, :home_scene, :pid)

    graph =
      [font: :roboto, font_size: @text_size]
      |> Graph.build()
      |> text("Joining", translate: {20, 40}, id: :status_text)

    scene = scene |> assign(graph: graph) |> push_graph(graph)
    {:ok, scene}
  end

  @impl GenServer
  def handle_info(:lost, scene) do
    graph = Graph.modify(scene.assigns.graph, :status_text, &text(&1, "Lost"))
    scene = scene |> assign(graph: graph) |> push_graph(graph)
    {:noreply, scene}
  end
end
