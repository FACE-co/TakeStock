class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @portfolios = Portfolio.where(user: current_user).order(:created_at)
    if params[:query].present?
      @stocks = Stock.search_by_name_and_ticker_and_sector(params[:query])
    else
      @stocks = Stock.all
    end

    @news = news
  end

  def about
  end

  private

  def news
    query = "https://newsapi.org/v2/everything?q=investment&lang=en&sortBy=popularity&apiKey=#{ENV['NEWS_API_KEY']}"
    # query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=#{enddate}&to=#{enddate}&sortBy=popularity&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    news = JSON.parse(stock_news)
    news['articles']
  end
end
