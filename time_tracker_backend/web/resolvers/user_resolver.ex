defmodule TimeTrackerBackend.UserResolver do
  def all(_args, _info) do
    {:ok, TimeTrackerBackend.Repo.all(User)}
  end
end
