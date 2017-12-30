defmodule Crafters.Repo.Migrations.AddMonthAndPreferences do
  use Ecto.Migration

  def change do
    create table(:months, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :date
      add :last, :date

      timestamps()
    end

    create table(:slots) do
      add :date, :date
      add :timeslot, :string

      add :preference_id, references(:preferences, type: :binary_id)

      timestamps()
    end

    alter table(:preferences) do
      add :name, :string
      add :month_id, references(:months, type: :binary_id)
    end
  end
end
