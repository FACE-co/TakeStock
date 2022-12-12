class NewsController < ApplicationController
  def index
    @stock = Stock.friendly.find(params[:stock_id])
    @newsdate = params[:enddate]
    query = "https://newsapi.org/v2/everything?q=#{@stock.ticker}&from=#{@newsdate}&to=#{@newsdate}&sortBy=popularity&apiKey=#{ENV['NEWS_API_KEY']}"
    # query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=#{enddate}&to=#{enddate}&sortBy=popularity&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    @news_hash = JSON.parse(stock_news)
    return @news_hash
  end
end
