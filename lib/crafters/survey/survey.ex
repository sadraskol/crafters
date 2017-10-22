defmodule Crafters.Survey do
  @moduledoc """
  The Survey context.
  """

  import Ecto.Query, warn: false
  alias Crafters.Repo

  alias Crafters.Survey.Preference

  @doc """
  Returns the list of preferences.

  ## Examples

      iex> list_preferences()
      [%Preference{}, ...]

  """
  def list_preferences do
    Repo.all(Preference)
  end

  @doc """
  Gets a single preference.

  Raises `Ecto.NoResultsError` if the Preference does not exist.

  ## Examples

      iex> get_preference!(123)
      %Preference{}

      iex> get_preference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_preference!(id), do: Repo.get!(Preference, id)

  @doc """
  Creates a preference.

  ## Examples

      iex> create_preference(%{field: value})
      {:ok, %Preference{}}

      iex> create_preference(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_preference(attrs \\ %{}) do
    %Preference{}
    |> Preference.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a preference.

  ## Examples

      iex> update_preference(preference, %{field: new_value})
      {:ok, %Preference{}}

      iex> update_preference(preference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_preference(%Preference{} = preference, attrs) do
    preference
    |> Preference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Preference.

  ## Examples

      iex> delete_preference(preference)
      {:ok, %Preference{}}

      iex> delete_preference(preference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_preference(%Preference{} = preference) do
    Repo.delete(preference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking preference changes.

  ## Examples

      iex> change_preference(preference)
      %Ecto.Changeset{source: %Preference{}}

  """
  def change_preference(%Preference{} = preference) do
    Preference.changeset(preference, %{})
  end
end
