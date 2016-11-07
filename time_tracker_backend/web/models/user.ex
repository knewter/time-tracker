defmodule TimeTrackerBackend.User do
  use TimeTrackerBackend.Web, :model

  schema "users" do
    field :name, :string
    field :gender, :string
    field :email, :string
    field :username, :string
    field :password, :string
    field :is_active, :boolean, default: false
    field :deleted, :boolean, default: false
    field :is_superuser, :boolean, default: false
    field :avatar, :string, default: "/static/img/no-avatar.png"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :gender,
      :email,
      :username,
      :password,
      :is_active,
      :deleted,
      :is_superuser,
      :avatar
    ])
    |> validate_required([
      :name,
      :gender,
      :email,
      :username,
      :password,
      :is_active,
      :is_superuser,
      :avatar
    ])
    |> unique_constraint(:name)
  end
end
