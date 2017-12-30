defmodule CraftersWeb.Router do
  use CraftersWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CraftersWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/new_month", PageController, :new_month
    post "/create_month", PageController, :create_month
    get "/delete_month/:id", PageController, :delete_month

    get "/month/:id", PageController, :month
    get "/month/:id/new_preference", PageController, :new_preference
  end

  scope "/api", CraftersWeb.Api do
    pipe_through :api

    post "/preferences/:id", PreferencesController, :submit_preferences
  end
end
