defmodule TimeTrackerBackend.UserResolver do
  @moduledoc """
  Functions used to resolve user-related data for our GraphQL endpoint
  """

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

  def create(args, _info) do
    changeset = User.changeset(%User{}, args)

    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, inspect(changeset.errors)}
    end
  end
end
