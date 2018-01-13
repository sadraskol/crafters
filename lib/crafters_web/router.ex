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

    get "/", PageController, :current_month

    scope "/months" do
      # TODO add a pipeline for a basic or complete authentication
      get "/", PageController, :index
      get "/new_month", PageController, :new_month
      post "/create_month", PageController, :create_month
      get "/:id/delete_month", PageController, :delete_month
      get "/:id/current_month", PageController, :set_current_month

      get "/:id", PageController, :month
      get "/:id/new_preference", PageController, :new_preference
    end
  end

  scope "/api", CraftersWeb.Api do
    pipe_through :api

    post "/preferences/:id", PreferencesController, :submit_preferences
  end
end
