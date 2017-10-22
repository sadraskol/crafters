defmodule Crafters.Repo.Migrations.CreatePreferences do
  use Ecto.Migration

  def change do
    create table(:preferences, primary_key: false) do
      add :id, :binary_id, primary_key: true

      timestamps()
    end

  end
end
