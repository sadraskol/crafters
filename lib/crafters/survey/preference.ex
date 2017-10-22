defmodule Crafters.Survey.Preference do
  use Ecto.Schema
  import Ecto.Changeset
  alias Crafters.Survey.Preference


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "preferences" do

    timestamps()
  end

  @doc false
  def changeset(%Preference{} = preference, attrs) do
    preference
    |> cast(attrs, [])
    |> validate_required([])
  end
end
