defmodule TimeTrackerBackend.ProjectController do
  use TimeTrackerBackend.Web, :controller

  defp search(query, %{"q" => q}) do
    from u in query,
      where: ilike(u.name, ^"%#{q}%")
  end
  defp search(query, _), do: query

  def index(conn, params) do
    page =
      Project
      |> search(params)
      |> order(params["order"])
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", projects: page.entries)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_path(conn, :show, project))
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get!(Project, id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        render(conn, "show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    send_resp(conn, :no_content, "")
  end
end
