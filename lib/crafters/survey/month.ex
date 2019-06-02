defmodule Crafters.Survey.Month do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.{Activity, Month}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :range]}
  schema "months" do
    field(:start, :date)
    field(:last, :date)
    field(:current, :boolean)
    field(:range, :any, virtual: true)
    field(:date_range, :any, virtual: true)
    field(:best_ddd, :any, virtual: true)
    field(:best_evening_dojo, :any, virtual: true)
    field(:best_lunch_dojo, :any, virtual: true)

    has_many(:preferences, Crafters.Survey.Preference, on_delete: :delete_all)
    timestamps()
  end

  def changeset(%Month{} = month, attrs) do
    month
    |> cast(attrs, [:start, :last])
    |> validate_required([:start, :last])
  end

  def list_best_dates(%Month{} = month) do
    month
    |> Map.put(:best_ddd, show_best_dates(month, "ddd"))
    |> Map.put(:best_evening_dojo, show_best_dates(month, "evening_dojo"))
    |> Map.put(:best_lunch_dojo, show_best_dates(month, "lunch_dojo"))
  end

  defp show_best_dates(month, activity) do
    month.preferences
    |> Enum.filter(fn preference -> contains_activity(preference.activities, activity) end)
    |> Enum.flat_map(fn preference -> preference.slots end)
    |> Enum.group_by(fn slot -> {slot.date, slot.timeslot} end)
    |> Enum.map(fn {key, group} -> {key, Enum.count(group)} end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.filter(fn {key, _count} -> elem(key, 1) == Activity.timeslot(activity) end)
    |> Enum.take(5)
    |> Enum.map(fn {key, count} -> {elem(key, 0), count} end)
  end

  defp contains_activity(activities, activity) do
    activities
    |> Enum.map(fn activity -> activity.name end)
    |> Enum.member?(activity)
  end

  def set_range(%Month{} = month) do
    range =
      Date.range(month.start, month.last)
      |> Enum.filter(fn date -> !Enum.member?([6, 7], Date.day_of_week(date)) end)
      |> Enum.map(fn date -> %{day: date.day, month: date.month, year: date.year} end)
      |> Enum.to_list()

    Map.put(month, :range, range)
  end

  def set_date_range(%Month{} = month) do
    range =
      Date.range(month.start, month.last)
      |> Enum.filter(fn date -> !Enum.member?([6, 7], Date.day_of_week(date)) end)

    Map.put(month, :date_range, range)
  end
end
