defmodule Crafters.Survey.Activity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.Activity

  @foreign_key_type :binary_id
  @derive {Jason.Encoder, except: [:__meta__]}
  schema "activities" do
    field(:name, :string)

    belongs_to(:preference, Crafters.Survey.Preference)

    timestamps()
  end

  def changeset(%Activity{} = activity, %{"name" => _name} = params) do
    activity
    |> cast(params, [:name])
    |> validate_inclusion(:name, ["ddd", "evening_dojo", "lunch_dojo"])
  end

  def from_name(name) do
    %{"name" => name}
  end

  def timeslot("ddd"), do: "evening"
  def timeslot("evening_dojo"), do: "evening"
  def timeslot("lunch_dojo"), do: "lunch"
end
