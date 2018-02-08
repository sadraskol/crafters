defmodule Crafters.ReleaseTasks do

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  def myapp, do: :crafters

  def repos, do: Application.get_env(myapp(), :ecto_repos, [])

  defp prepare do
    me = myapp()

    IO.puts "Loading #{me}.."
    :ok = Application.load(me)

    IO.puts "Starting dependencies.."
    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  def create do
    prepare()
    Enum.each repos(), fn repo ->
      case repo.__adapter__.storage_up(repo.config) do
        :ok ->
          IO.puts "The database for #{inspect repo} has been created"
        {:error, :already_up} ->
          IO.puts "The database for #{inspect repo} has already been created"
        {:error, term} when is_binary(term) ->
          IO.puts :stderr, "The database for #{inspect repo} couldn't be created: #{term}"
          exit 1
        {:error, term} ->
          IO.puts :stderr, "The database for #{inspect repo} couldn't be created: #{inspect term}"
          exit 1
      end
    end
  end

  def migrate do
    prepare()

    IO.puts "Starting repos.."
    Enum.each(repos(), &(&1.start_link(pool_size: 1)))

    Enum.each(repos(), &run_migrations_for/1)
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  def migrations_path(repo), do: priv_path_for(repo, "migrations")

  def priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
