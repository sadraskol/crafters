defmodule Crafters.Survey.Slot do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.Slot

  @foreign_key_type :binary_id
  @derive {Poison.Encoder, except: [:__meta__]}
  schema "slots" do
    field(:date, :date)
    field(:timeslot, :string)

    belongs_to(:preference, Crafters.Survey.Preference)

    timestamps()
  end

  def changeset(%Slot{} = slot, %{
        "date" => %{"year" => year, "month" => month, "day" => day},
        "timeslot" => timeslot
      }) do
    cast(slot, %{"date" => Date.from_erl!({year, month, day}), "timeslot" => timeslot}, [
      :date,
      :timeslot
    ])
  end
end
