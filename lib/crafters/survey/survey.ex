defmodule Crafters.Survey do
  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Crafters.Repo

  alias Crafters.Survey.{Activity, Preference, Month}

  def get_all_months(), do: Repo.all(Month)

  def get_month!(id) do
    Repo.get!(Month, id)
    |> Repo.preload(preferences: [:slots, :activities])
    |> Month.list_best_dates()
    |> Month.set_range()
    |> Month.set_date_range()
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

  def put_preference(id, slots, activities) do
    Repo.get!(Month, id)
    |> Ecto.build_assoc(:preferences)
    |> Preference.changeset(%{slots: slots, activities: Enum.map(activities, &Activity.from_name/1)})
    |> Repo.insert()
  end

  def get_current_month() do
    Repo.get_by!(Month, current: true)
    |> Repo.preload(preferences: [:slots, :activities])
    |> Month.list_best_dates()
    |> Month.set_range()
    |> Month.set_date_range()
  end

  def set_current_month(id) do
    Multi.new
    |> Multi.update_all(:remove_current, from(m in Month, where: m.current == true), set: [current: false])
    |> Multi.update_all(:set_current, from(m in Month, where: m.id == ^id), set: [current: true])
    |> Repo.transaction()
  end
end
