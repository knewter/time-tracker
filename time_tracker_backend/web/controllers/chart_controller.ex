defmodule TimeTrackerBackend.ChartController do
  use TimeTrackerBackend.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.json", data: static_data())
  end

  defp static_data() do
    [
      [ 1448928000000, 2 ],
      [ 1451606400000, 2 ],
      [ 1454284800000, 1 ],
      [ 1456790400000, 1 ]
    ]
  end
end
