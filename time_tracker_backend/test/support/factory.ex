defmodule TimeTrackerBackend.Factory do
  use ExMachina.Ecto, repo: TimeTrackerBackend.Repo
  alias TimeTrackerBackend.{User, Project, Organization}

  def user_factory do
    %User{
      name: sequence(:name, &("Some User - #{&1}")),
      avatar: "prueba_avatar.png",
      email: "user_1@systrix.net",
      gender: "Female",
      is_active: true,
      is_superuser: true,
      password: "1234",
      username: sequence(:username, &("sys.user_#{&1}")),
    }
  end

  def project_factory do
    %Project{
      name: sequence(:name, &("Some Project - #{&1}"))
    }
  end

  def organization_factory do
    %Organization{
      name: sequence(:name, &("Some Organization - #{&1}"))
    }
  end
end
