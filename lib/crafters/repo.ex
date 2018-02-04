defmodule Crafters.Repo do
  use Ecto.Repo, otp_app: :crafters

  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("ECTO_PG_URL"))}
  end
end
