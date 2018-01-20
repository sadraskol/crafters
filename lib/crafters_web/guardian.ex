defmodule CraftersWeb.Guardian do
  def control(login, password) do
    case {login, password} do
       {"thomas", "thomas"} -> :authorized
       _ -> :unauthorized
    end
  end
end
