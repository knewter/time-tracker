defmodule TimeTrackerBackend.Project do
  @moduledoc """
  Projects in our system
  """

  use TimeTrackerBackend.Web, :model

  schema "projects" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
