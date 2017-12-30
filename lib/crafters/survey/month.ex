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

    has_many :preferences, Crafters.Survey.Preference
    timestamps()
  end

  @doc false
  def changeset(%Month{} = month, attrs) do
    month
    |> cast(attrs, [:start, :last])
    |> validate_required([:start, :last])
  end
end
