defmodule TimeTrackerBackend.UserResolver do
  alias TimeTrackerBackend.{Repo, User}

  def all(_args, _info) do
    {:ok, Repo.all(User)}
  end

  def find(%{id: id}, _info) do
    case Repo.get(User, id) do
      nil -> {:error, "No user found with id #{id}"}
      user -> {:ok, user}
    end
  end
end
