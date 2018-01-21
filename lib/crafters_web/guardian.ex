defmodule CraftersWeb.Guardian do
  def control(login, password) do
    if Enum.member?(credentials(), {login, password}) do
      :authorized
    else
      :unauthorized
    end
  end

  def credentials do
    creds = System.get_env("CRAFTERS_CREDENTIALS") || "thomas:thomas"
    creds
    |> String.split(",")
    |> Enum.map(fn(str) -> String.split(str, ":") end)
    |> Enum.map(&List.to_tuple/1)
  end
end
