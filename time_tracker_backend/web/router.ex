defmodule TimeTrackerBackend.Router do
  use TimeTrackerBackend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTrackerBackend do
    pipe_through :api # Use the default browser stack

    get "/users", UserController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimeTrackerBackend do
  #   pipe_through :api
  # end
end
