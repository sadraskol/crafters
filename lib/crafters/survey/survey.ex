defmodule Crafters.Survey do

  import Ecto.Query, warn: false
  alias Crafters.Repo

  alias Crafters.Survey.{Preference, Month, Slot}

  def get_all_months(), do: Repo.all(Month)

  def get_month!(id) do
    Repo.get!(Month, id)
    |> Repo.preload(preferences: :slots)
    |> Month.list_best_dates()
    |> Month.set_range()
  end

  def put_month(attrs \\ %{}) do
    %Month{}
    |> Month.changeset(attrs)
    |> Repo.insert()
  end

  def delete_month(id) do
    Repo.get!(Month, id)
    |> Repo.delete!()
  end

  def new_month() do
    %Month{start: Date.utc_today(), last: Date.utc_today()}
    |> Ecto.Changeset.cast(%{}, [:start, :last])
  end

  def put_preference(id, name, slots, activities \\ []) do
    Repo.get!(Month, id)
    |> Ecto.build_assoc(:preferences)
    |> Preference.changeset(%{name: name, slots: slots, activities: activities})
    |> Repo.insert()
  end
end
