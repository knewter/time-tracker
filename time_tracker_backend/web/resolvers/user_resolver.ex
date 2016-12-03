defmodule TimeTrackerBackend.UserResolver do
  alias TimeTrackerBackend.{Repo, User}

  def all(_args, _info) do
    {:ok, Repo.all(User)}
  end
end
