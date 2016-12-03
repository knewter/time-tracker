defmodule TimeTrackerBackend.Schema do
  use Absinthe.Schema
  import_types TimeTrackerBackend.Schema.Types

  mutation do
    @desc "Create a user"
    field :user, type: :user do
      arg :name, non_null(:string)
      arg :gender, non_null(:string)
      arg :email, non_null(:string)
      arg :username, non_null(:string)
      arg :avatar, non_null(:string)
      arg :password, non_null(:string)

      resolve &TimeTrackerBackend.UserResolver.create/2
    end
  end

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
