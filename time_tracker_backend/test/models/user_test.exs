defmodule TimeTrackerBackend.UserTest do
  use TimeTrackerBackend.ModelCase

  alias TimeTrackerBackend.{User, Repo}

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "names are unique" do
    IO.inspect User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    IO.inspect User.changeset(%User{}, @valid_attrs) |> Repo.insert!
  end
end
