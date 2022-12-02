class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @portfolios = Portfolio.where(user: current_user)
    @stocks = Stock.all
    @new_stock = Stock.new
  end

  def basic_info
  end

  def twitter_feed
  end

  def live_chart
  end

  def medium_feed
  end

  def ticker_news
  end
end
