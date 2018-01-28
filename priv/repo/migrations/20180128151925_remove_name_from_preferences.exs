defmodule Crafters.Repo.Migrations.RemoveNameFromPreferences do
  use Ecto.Migration

  def change do
    alter table(:preferences) do
      remove :name
    end
  end
end
