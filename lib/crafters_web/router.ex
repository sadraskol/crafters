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

  pipeline :auth do
    plug PlugBasicAuth, validation: &CraftersWeb.Guardian.control/2
  end

  scope "/", CraftersWeb do
    pipe_through :browser # Use the default browser stack

    scope "/months" do
      pipe_through :auth

      get "/", PageController, :index
      get "/new_month", PageController, :new_month
      post "/create_month", PageController, :create_month
      get "/:id/delete_month", PageController, :delete_month
      get "/:id/current_month", PageController, :set_current_month
    end

    get "/", PageController, :current_month
    get "/months/:id", PageController, :month
    get "/months/:id/new_preference", PageController, :new_preference
  end

  scope "/api", CraftersWeb.Api do
    pipe_through :api

    post "/preferences/:id", PreferencesController, :submit_preferences
  end
end
