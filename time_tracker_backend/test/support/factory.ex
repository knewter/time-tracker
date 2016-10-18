defmodule TimeTrackerBackend.Factory do
  use ExMachina.Ecto, repo: TimeTrackerBackend.Repo
  alias TimeTrackerBackend.{User, Project, Organization}

  def user_factory do
    %User{
      name: sequence(:name, &("Some User - #{&1}"))
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
