defmodule TimeTrackerBackend.Repo.Migrations.AddUniquenessConstraintToProjectsName do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      modify :name, :string, unique: true
    end
    create unique_index(:projects, [:name])
  end
end
