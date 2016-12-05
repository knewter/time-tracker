defmodule TimeTrackerBackend.ChartController do
  use TimeTrackerBackend.Web, :controller

  def index(conn, _params) do
    conn
      |> render("index.json", data: static_data())
  end

  defp static_data() do
    [
      [1_448_928_000_000, 2],
      [1_451_606_400_000, 2],
      [1_454_284_800_000, 1],
      [1_456_790_400_000, 1]
    ]
  end
end
