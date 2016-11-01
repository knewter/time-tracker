defmodule TimeTrackerBackend.OrganizationControllerTest do
  use TimeTrackerBackend.ConnCase
  import TimeTrackerBackend.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "paginates entries on index", %{conn: conn} do
    insert_list(12, :organization)
    conn = get conn, organization_path(conn, :index)
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
    insert_list(12, :organization)
    insert(:organization, %{name: "jabbity"})
    conn = get conn, organization_path(conn, :index, %{q: "jabbit"})
    response = json_response(conn, 200)["data"]
    assert (hd response)["name"] == "jabbity"
  end

  test "shows chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = get conn, organization_path(conn, :show, organization)
    assert json_response(conn, 200)["data"] == %{"id" => organization.id,
      "name" => organization.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, organization_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), organization: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), organization: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), organization: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = delete conn, organization_path(conn, :delete, organization)
    assert response(conn, 204)
    refute Repo.get(Organization, organization.id)
  end
end
