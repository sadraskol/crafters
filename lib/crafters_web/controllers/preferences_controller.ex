defmodule CraftersWeb.Api.PreferencesController do
  use CraftersWeb, :controller

  def submit_preferences(conn, %{"id" => id, "slots" => slots, "activities" => activities}) do
    Crafters.Survey.put_preference(id, slots, activities)
    json(conn, %{})
  end
end
