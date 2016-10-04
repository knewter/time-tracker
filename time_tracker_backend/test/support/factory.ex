defmodule TimeTrackerBackend.Factory do
  use ExMachina.Ecto, repo: TimeTrackerBackend.Repo
  alias TimeTrackerBackend.User

  def user_factory do
    %User{
      name: sequence(:name, &("Some Name - #{&1}"))
    }
  end
end
