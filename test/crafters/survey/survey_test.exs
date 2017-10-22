defmodule Crafters.SurveyTest do
  use Crafters.DataCase

  alias Crafters.Survey

  describe "preferences" do
    alias Crafters.Survey.Preference

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def preference_fixture(attrs \\ %{}) do
      {:ok, preference} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Survey.create_preference()

      preference
    end

    test "list_preferences/0 returns all preferences" do
      preference = preference_fixture()
      assert Survey.list_preferences() == [preference]
    end

    test "get_preference!/1 returns the preference with given id" do
      preference = preference_fixture()
      assert Survey.get_preference!(preference.id) == preference
    end

    test "create_preference/1 with valid data creates a preference" do
      assert {:ok, %Preference{} = preference} = Survey.create_preference(@valid_attrs)
    end

    test "create_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_preference(@invalid_attrs)
    end

    test "update_preference/2 with valid data updates the preference" do
      preference = preference_fixture()
      assert {:ok, preference} = Survey.update_preference(preference, @update_attrs)
      assert %Preference{} = preference
    end

    test "update_preference/2 with invalid data returns error changeset" do
      preference = preference_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_preference(preference, @invalid_attrs)
      assert preference == Survey.get_preference!(preference.id)
    end

    test "delete_preference/1 deletes the preference" do
      preference = preference_fixture()
      assert {:ok, %Preference{}} = Survey.delete_preference(preference)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_preference!(preference.id) end
    end

    test "change_preference/1 returns a preference changeset" do
      preference = preference_fixture()
      assert %Ecto.Changeset{} = Survey.change_preference(preference)
    end
  end
end
