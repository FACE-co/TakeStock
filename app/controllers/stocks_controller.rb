class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    @news_hash = news(@stock)
  end

  # /stocks(.:format)
  def create
    @new_stock = Stock.new(call_ticker_api(stock_params))
    if @new_stock.save
      redirect_to stock_path(@new_stock)
    else
      redirect_to root_path, notice: "Can't create duplicate stock"
    end
  end

  # /stocks/:id(.:format)
  def update
    @stock = Stock.friendly.find(params[:id])
    if @stock.update(call_ticker_api(stock_params))
      redirect_to stock_path(@stock)
    else
      redirect_to root_path, notice: "Can't update"
    end
  end

  # /stocks/:id(.:format)
  def destroy
    @stock = Stock.friendly.find(params[:id])
    @stock.destroy
  end

  # /stocks/trending(.:format)
  def trending
  end



  private

  def stock_params
    params.require(:stock).permit(:ticker)
  end

  def call_ticker_api(stock_params)
    query = "https://api.sec-api.io/mapping/ticker/#{stock_params[:ticker]}?token=#{ENV['SEC_API_KEY']}"
    stock_serialized = URI.open(query).read
    stock_info = JSON.parse(stock_serialized).first
    stock_info["api_id"] = stock_info.delete("id")
    return stock_info
  end

  # /stock_news
  def news(stock)
    query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=2022-10-30&sortBy=publishedAt&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    news_hash = JSON.parse(stock_news)
    return news_hash
  end
end
