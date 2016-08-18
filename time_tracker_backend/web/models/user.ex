defmodule TimeTrackerBackend.User do
  use TimeTrackerBackend.Web, :model

  schema "users" do
    field :name, :string
  end
end
