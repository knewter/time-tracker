defmodule TimeTrackerBackend.Router do
  use TimeTrackerBackend.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  forward "/graphql", Absinthe.Plug,
    schema: TimeTrackerBackend.Schema

  scope "/", TimeTrackerBackend do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/projects", ProjectController, except: [:new, :edit]
    resources "/organizations", OrganizationController, except: [:new, :edit]
    resources "/sessions", SessionController, only: [:create]
    resources "/charts", ChartController, only: [:index]
  end
end
