defmodule TimeTrackerBackend.SessionController do
  use TimeTrackerBackend.Web, :controller

  # If you give us the hardcoded username and password, we give you a token on
  # bob if he exists.  If not, we create him and give you a token on the
  # newly-created bob because **this is not authentication**.
  #
  # NOTE: YOU OBVIOUSLY DO NOT WANT TO USE THIS IN YOUR OWN CODE PLEASE DO NOT
  # DO THAT IF YOU THINK YOU MAYBE SHOULD.
  def create(conn, %{"username" => "bob", "password" => "secret"}) do
    query = from u in User, where: u.name == "Bob"

    user =
      case query |> first |> Repo.one do
        nil -> %User{name: "Bob"} |> Repo.insert!
        bob -> bob
      end

    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    {:ok, claims} = Guardian.Plug.claims(new_conn)
    exp = Map.get(claims, "exp")

    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")
      |> json(%{ "token" => jwt })
  end
  def create(conn, _) do
    conn
      |> put_status(:unauthorized)
      |> json("UNAUTHORIZED")
  end
end
