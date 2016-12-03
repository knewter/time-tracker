defmodule TimeTrackerBackend.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :gender, :string
    field :email, :string
    field :username, :string
    field :is_active, :boolean
    field :avatar, :string
  end
end
