defmodule TimeTrackerBackend.UserControllerTest do
  use TimeTrackerBackend.ConnCase
  import TimeTrackerBackend.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "when unauthenticated" do
    test "cannot list entries", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 401)
    end
  end

  describe "when authenticated" do
    setup [:set_auth_headers]

    test "paginates entries on index", %{conn: conn} do
      insert_list(12, :user)
      conn = get conn, user_path(conn, :index)
      response = json_response(conn, 200)["data"]
      assert get_resp_header(conn, "total") == ["13"]
      assert get_resp_header(conn, "per-page") == ["10"]
      assert get_resp_header(conn, "total-pages") == ["2"]
      assert get_resp_header(conn, "page-number") == ["1"]
      link_header = get_resp_header(conn, "link") |> hd |> ExLinkHeader.parse!
      assert "2" == link_header.next.params.page
      assert "2" == link_header.last.params.page
      assert "1" == link_header.first.params.page
      assert length(response) == 10
    end

    test "searches entries on index with query", %{conn: conn} do
      insert_list(12, :user)
      insert(:user, %{name: "jabbity"})
      conn = get conn, user_path(conn, :index, %{q: "jabbit"})
      response = json_response(conn, 200)["data"]
      assert (hd response)["name"] == "jabbity"
    end

    test "shows chosen resource", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = get conn, user_path(conn, :show, user)
      assert json_response(conn, 200)["data"] == %{"id" => user.id,
       "name" => user.name}
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, -1)
      end
    end

    test "creates and renders resource when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @valid_attrs
      assert json_response(conn, 201)["data"]["id"]
      assert Repo.get_by(User, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "updates and renders chosen resource when data is valid", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = put conn, user_path(conn, :update, user), user: @valid_attrs
      assert json_response(conn, 200)["data"]["id"]
      assert Repo.get_by(User, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "deletes chosen resource", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      refute Repo.get(User, user.id)
    end
  end

  def set_auth_headers(%{conn: conn}) do
    bob = %User{name: "Bob"} |> Repo.insert!
    new_conn = Guardian.Plug.api_sign_in(conn, bob)
    jwt = Guardian.Plug.current_token(new_conn)
    %{ conn: conn |> put_req_header("authorization", "Bearer #{jwt}") }
  end
end
