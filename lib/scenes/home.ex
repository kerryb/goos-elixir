defmodule AuctionSniper.Scene.Home do
  @moduledoc false
  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph

  require Logger

  # import Scenic.Components

  @note """
    This is a very simple starter application.

    If you want a more full-on example, please start from:

    mix scenic.new.example
  """

  @text_size 24

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(scene, _param, _opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    {width, height} = scene.viewport.size

    # show the version of scenic and the glfw driver
    scenic_ver = :scenic |> Application.spec(:vsn) |> to_string()
    driver_ver = :scenic_driver_local |> Application.spec(:vsn) |> to_string()

    info = "scenic: v#{scenic_ver}\nscenic_driver_local: v#{driver_ver}"

    graph =
      [font: :roboto, font_size: @text_size]
      |> Graph.build()
      |> add_specs_to_graph([
        text_spec(info, translate: {20, 40}),
        text_spec(@note, translate: {20, 120}),
        rect_spec({width, height})
      ])

    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end
end
