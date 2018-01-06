defmodule Crafters.Repo.Migrations.AddActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string

      add :preference_id, references(:preferences, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end
  end
end
