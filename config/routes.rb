Rails.application.routes.draw do
  devise_for :users

  root to: "dashboard#show"
  resources :dashboard, only: [] do
    collection do
      get :basic_info
      get :twitter_feed
      get :live_chart
      get :medium_feed
      get :ticker_news
    end
  end

  # get "stocks/:ticker", to: "stocks#show"

  resources :portfolios, only: [:show, :create, :update, :destroy]

  resources :stocks, only: [:show, :create, :update, :destroy] do
    collection do
      get :trending
    end
  end

  resources :portfolio_stocks, only: [:create, :destroy]
end
