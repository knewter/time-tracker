defmodule TimeTrackerBackend.SessionControllerTest do
  use TimeTrackerBackend.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "logs in as bob", %{conn: conn} do
    conn = post conn, session_path(conn, :create), %{ username: "bob", password: "secret" }
    assert json_response(conn, 200)
    assert Regex.match?(~r/Bearer/, get_resp_header(conn, "authorization") |> hd)
  end
end
