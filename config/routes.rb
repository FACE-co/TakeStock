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

  resources :dashboard
  # get "stocks/:ticker", to: "stocks#show"

  resources :portfolios, only: [:show, :create, :update, :destroy] do
    # nested bec
    resources :portfolio_stocks, only: [:create]
  end

  resources :stocks, only: [:show, :create, :update, :destroy] do
    collection do
      get :trending
    end
    member do
      get :tweets
    end
  end

  # only need id of portfolio_stock to destroy (So we don't nest this route)
  resources :portfolio_stocks, only: [:destroy]
end
