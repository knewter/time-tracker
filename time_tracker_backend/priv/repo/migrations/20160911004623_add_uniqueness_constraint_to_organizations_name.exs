defmodule TimeTrackerBackend.Repo.Migrations.AddUniquenessConstraintToOrganizationsName do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      modify :name, :string, unique: true
    end
    create unique_index(:organizations, [:name])
  end
end
