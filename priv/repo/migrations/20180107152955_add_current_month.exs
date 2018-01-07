defmodule Crafters.Repo.Migrations.AddCurrentMonth do
  use Ecto.Migration

  def change do
    alter table(:months) do
      add :current, :boolean
    end
  end
end
