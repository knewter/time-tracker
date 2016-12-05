defmodule TimeTrackerBackend.OrganizationController do
  use TimeTrackerBackend.Web, :controller

  alias TimeTrackerBackend.Organization

  defp search(query, %{"q" => q}) do
    from u in query,
      where: ilike(u.name, ^"%#{q}%")
  end
  defp search(query, _), do: query

  def index(conn, params) do
    page =
      Organization
      |> search(params)
      |> order(params["order"])
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", organizations: page.entries)
  end

  def create(conn, %{"organization" => organization_params}) do
    changeset = Organization.changeset(%Organization{}, organization_params)

    case Repo.insert(changeset) do
      {:ok, organization} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", organization_path(conn, :show, organization))
        |> render("show.json", organization: organization)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Repo.get!(Organization, id)
    render(conn, "show.json", organization: organization)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Repo.get!(Organization, id)
    changeset = Organization.changeset(organization, organization_params)

    case Repo.update(changeset) do
      {:ok, organization} ->
        render(conn, "show.json", organization: organization)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Repo.get!(Organization, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(organization)

    send_resp(conn, :no_content, "")
  end
end
