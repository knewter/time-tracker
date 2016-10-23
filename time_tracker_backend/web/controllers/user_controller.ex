defmodule TimeTrackerBackend.UserController do
  use TimeTrackerBackend.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  defp search(query, %{ "q" => q }) do
    from u in query,
      where: ilike(u.name, ^"%#{q}%")
  end
  defp search(query, _), do: query

  def index(conn, params) do
    page =
      User
      |> search(params)
      |> Repo.paginate(params)

    # We'll make the users index action take a little while so we can be sure
    # that the user experience handles slower responses well / doesn't look
    # stupid.
    :timer.sleep(5_000)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", users: page.entries)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeTrackerBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json("Authentication required")
  end
end
