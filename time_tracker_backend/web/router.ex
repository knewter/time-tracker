defmodule TimeTrackerBackend.Router do
  use TimeTrackerBackend.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTrackerBackend do
    pipe_through :api

    resources "/users", UserController
  end
end
