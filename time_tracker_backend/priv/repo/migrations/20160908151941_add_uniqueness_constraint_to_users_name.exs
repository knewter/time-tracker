defmodule TimeTrackerBackend.Repo.Migrations.AddUniquenessConstraintToUsersName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :name, :string, unique: true
    end
    create unique_index(:users, [:name])
  end
end
