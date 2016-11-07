defmodule TimeTrackerBackend.UserView do
  use TimeTrackerBackend.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, TimeTrackerBackend.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TimeTrackerBackend.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      avatar: user.avatar,
      email: user.email,
      gender: user.gender,
      is_active: user.is_active,
      is_superuser: user.is_superuser,
      username: user.username
    }
  end
end
