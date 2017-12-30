defmodule CraftersWeb.Api.PreferencesController do
  use CraftersWeb, :controller

  def submit_preferences(conn, %{"id" => id, "name" => name, "slots" => slots}) do
    Crafters.Survey.put_preference(id, name, slots)
    json(conn, %{})
  end
end
