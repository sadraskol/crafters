defmodule Crafters.Survey.Month do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.Month

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, only: [:id, :range]}
  schema "months" do
    field :start, :date
    field :last, :date
    field :range, :any, virtual: true
    field :best_lunches, :any, virtual: true
    field :best_evenings, :any, virtual: true

    has_many :preferences, Crafters.Survey.Preference
    timestamps()
  end

  def changeset(%Month{} = month, attrs) do
    month
    |> cast(attrs, [:start, :last])
    |> validate_required([:start, :last])
  end

  def list_best_dates(%Month{} = month) do
    bests = month.preferences
    |> Enum.flat_map(fn(preference) -> preference.slots end)
    |> Enum.group_by(fn(slot) -> {slot.date, slot.timeslot} end)
    |> Enum.map(fn({key, group}) -> {key, Enum.count(group)} end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)

    month
    |> Map.put(:best_lunches, show_only_dates(bests, "lunch"))
    |> Map.put(:best_evenings, show_only_dates(bests, "evening"))
  end

  defp show_only_dates(bests, timeslot) do
    bests
    |> Enum.filter(fn({key, _count}) -> elem(key, 1) == timeslot end)
    |> Enum.take(5)
    |> Enum.map(fn({key, count}) -> { elem(key, 0), count } end)
  end

  def set_range(%Month{} = month) do
    range = Date.range(month.start, month.last)
    |> Enum.filter(fn (date) -> !Enum.member?([6, 7], Date.day_of_week(date)) end)
    |> Enum.map(fn (date) -> %{ day: date.day, month: date.month, year: date.year } end)
    |> Enum.to_list()

    Map.put(month, :range, range)
  end
end
