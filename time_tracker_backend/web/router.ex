defmodule TimeTrackerBackend.Router do
  use TimeTrackerBackend.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTrackerBackend do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/projects", ProjectController, except: [:new, :edit]
    resources "/organizations", OrganizationController, except: [:new, :edit]
    resources "/sessions", SessionController, only: [:create]
  end
end
