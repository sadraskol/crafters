defmodule Crafters.Survey.Preference do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.Preference

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, except: [:__meta__]}
  schema "preferences" do
    belongs_to(:month, Crafters.Survey.Month)
    has_many(:slots, Crafters.Survey.Slot, on_delete: :delete_all)
    has_many(:activities, Crafters.Survey.Activity, on_delete: :delete_all)

    timestamps()
  end

  def changeset(%Preference{} = preference, attrs) do
    preference
    |> cast(attrs, [:month_id])
    |> cast_assoc(:slots)
    |> cast_assoc(:activities)
    |> foreign_key_constraint(:month_id)
  end
end
