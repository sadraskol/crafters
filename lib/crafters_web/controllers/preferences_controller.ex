defmodule CraftersWeb.Api.PreferencesController do
  use CraftersWeb, :controller

  def submit_preferences(conn, params) do
    IO.inspect(params)
    json(conn, %{})
  end
end
