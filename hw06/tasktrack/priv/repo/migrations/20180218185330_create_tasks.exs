defmodule Tasktrack.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string,null: false
      add :description, :text,null: false
      add :time_taken, :time
      add :status, :boolean, default: false, null: false
      add :assigned_to_id, references(:users, on_delete: :delete_all)
      add :assigned_by_id, references(:users, on_delete: :delete_all),null: false

      timestamps()
    end

    create index(:tasks, [:assigned_to_id])
    create index(:tasks, [:assigned_by_id])
  end
end
