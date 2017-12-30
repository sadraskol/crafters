defmodule Crafters.Survey do

  import Ecto.Query, warn: false
  alias Crafters.Repo

  alias Crafters.Survey.{Preference, Month, Slot}

  def get_all_months(), do: Repo.all(Month)

  def get_month!(id) do
    month = Repo.get!(Month, id)
            |> Repo.preload preferences: :slots

    range = Date.range(month.start, month.last)
            |> Enum.filter(fn (date) -> !Enum.member?([6, 7], Date.day_of_week(date)) end)
            |> Enum.map(
                 fn (date) ->
                   %{
                     day: date.day,
                     month: date.month,
                     year: date.year
                   }
                 end
               )
            |> Enum.to_list()
    Map.put(month, :range, range)
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

  def put_preference(id, name, slots) do
    Repo.get!(Month, id)
    |> Ecto.build_assoc(:preferences)
    |> Preference.changeset(%{name: name, slots: slots})
    |> Repo.insert()
  end

end
