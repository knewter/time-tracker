defmodule TimeTrackerBackend.Schema do
  use Absinthe.Schema
  import_types TimeTrackerBackend.Schema.Types

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &TimeTrackerBackend.UserResolver.all/2
    end

    @desc "Get a single user"
    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &TimeTrackerBackend.UserResolver.find/2
    end
  end
end
