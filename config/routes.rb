Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get 'errors/bad_request'
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

  resources :portfolios, only: [:new, :show, :create, :edit, :update, :destroy] do
    # nested bec
    resources :portfolio_stocks, only: [:create]
  end

  resources :stocks, only: [:show, :create, :update, :destroy] do
    collection do
      get :trending
    end
    resources :tweets, only: [:index]
  end

  # only need id of portfolio_stock to destroy (So we don't nest this route)
  resources :portfolio_stocks, only: [:destroy]

  match "/404", via: :all, to: "errors#not_found"
  match "/500", via: :all, to: "errors#internal_server_error"
  match "/400", via: :all, to: "errors#bad_request"
end
