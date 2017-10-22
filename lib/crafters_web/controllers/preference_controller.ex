defmodule CraftersWeb.PreferenceController do
  use CraftersWeb, :controller

  alias Crafters.Survey
  alias Crafters.Survey.Preference

  def index(conn, _params) do
    slots = Date.range(~D[2017-10-01], ~D[2017-10-31])
    |> Enum.map(fn date -> %{date: date, times: [~T[12:00:00], ~T[19:00:00]]} end)
    render(conn, "index.html", slots: slots)
  end
end
