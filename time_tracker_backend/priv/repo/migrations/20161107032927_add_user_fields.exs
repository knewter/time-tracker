defmodule TimeTrackerBackend.Repo.Migrations.AddUserFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :gender, :string
      add :email, :string
      add :username, :string
      add :password, :string
      add :passwork_token, :string
      add :is_active, :boolean, default: false, null: false
      add :deleted, :boolean, default: false
      add :is_superuser, :boolean, default: false, null: false
      add :avatar, :string, default: "/static/img/no-avatar.png"
    end
  end
end
