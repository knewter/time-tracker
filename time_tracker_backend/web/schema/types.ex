defmodule TimeTrackerBackend.Schema.Types do
  use Absinthe.Schema.Notation

  @desc "A user of our system"
  object :user do
    field :id, :id
    field :name, :string, description: "The user's earth name"
    field :gender, :string
    field :email, :string
    field :username, :string
    field :is_active, :boolean
    field :avatar, :string
  end
end
