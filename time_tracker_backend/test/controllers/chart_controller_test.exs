defmodule TimeTrackerBackend.ChartControllerTest do
  use TimeTrackerBackend.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "returns chartable static data", %{conn: conn} do
    expected_chart_data = [
      [ 1448928000000, 2 ],
      [ 1451606400000, 2 ],
      [ 1454284800000, 1 ],
      [ 1456790400000, 1 ]
    ]
    conn = get conn, chart_path(conn, :index)
    response = json_response(conn, 200)["data"]
    assert response == expected_chart_data
  end
end
