defmodule CraftersWeb.PageController do
  use CraftersWeb, :controller

  def index(conn, _params) do
    range = Date.range(~D[2017-10-01], ~D[2017-10-31])
    |> Enum.map(fn(date) ->
      %{
        day: date.day,
        month: date.month,
        year: date.year
      }
    end)
    |> Enum.to_list()
    init = Poison.encode!(%{
      range: range,
      id: "super_id"
    })
    render conn, "index.html", init: init
  end
end
