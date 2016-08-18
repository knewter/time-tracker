defmodule TimeTrackerBackend.UserControllerTest do
  use TimeTrackerBackend.ConnCase
  alias TimeTrackerBackend.User

  test "GET / with no users", %{conn: conn} do
    conn = get conn, "/users"

    assert json_response(conn, 200) == []
  end

  describe "with a user" do
    setup [:insert_user]

    test "GET / with a user", %{conn: conn} do
      conn = get conn, "/users"

      assert json_response(conn, 200) == [%{"name" => "Josh"}]
    end
  end

  def insert_user(_context) do
    %User{name: "Josh"}
      |> Repo.insert!

    {:ok, []}
  end
end
