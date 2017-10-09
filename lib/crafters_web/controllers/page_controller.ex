defmodule CraftersWeb.PageController do
  use CraftersWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
