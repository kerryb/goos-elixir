defmodule AuctionSniper.Scene.Home do
  @moduledoc false
  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph

  require Logger

  # import Scenic.Components

  @text_size 24

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(scene, _param, _opts) do
    graph =
      [font: :roboto, font_size: @text_size]
      |> Graph.build()
      |> add_specs_to_graph([
        text_spec("Hello world", translate: {20, 40})
      ])

    scene = push_graph(scene, graph)

    {:ok, scene}
  end
end
