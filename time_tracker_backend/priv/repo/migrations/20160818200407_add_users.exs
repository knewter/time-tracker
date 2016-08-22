defmodule TimeTrackerBackend.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string

      timestamps()
    end
  end
end
