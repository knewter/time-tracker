defmodule TimeTrackerBackend.ProjectControllerTest do
  use TimeTrackerBackend.ConnCase
  import TimeTrackerBackend.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "paginates entries on index", %{conn: conn} do
    insert_list(12, :project)
    conn = get conn, project_path(conn, :index)
    response = json_response(conn, 200)["data"]
    assert get_resp_header(conn, "total") == ["12"]
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
    insert_list(12, :project)
    insert(:project, %{name: "jabbity"})
    conn = get conn, project_path(conn, :index, %{q: "jabbit"})
    response = json_response(conn, 200)["data"]
    assert (hd response)["name"] == "jabbity"
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200)["data"] == %{"id" => project.id,
      "name" => project.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = put conn, project_path(conn, :update, project), project: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
