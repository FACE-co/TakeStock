class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    # @news_hash = news(@stock)
  end

  # /stocks(.:format)
  def create
    ## TODO RE-ENABLE :PRODUCTION CODE - TO WORK WITH API
    # @new_stock = Stock.new(call_ticker_api(stock_params))

    # Temporary new_stock for local/testing
    # @new_stock = Stock.new(stock_params)
    # if @new_stock.save
    #   redirect_to stock_path(@new_stock)
    #   @stock = Stock.find_by(ticker: params[:stock][:ticker])
    # elsif @stock
    #   redirect_to @stock, status: :see_other
    # else
      @new_stock = Stock.new(stock_params)
      # @new_stock = Stock.new(call_ticker_api(stock_params))
      if @new_stock.save
        redirect_to stock_path(@new_stock), status: :see_other
      else
        @portfolios = []
        @stock = Stock.find_by(ticker: params[:stock][:ticker]) || Stock.find_by(ticker: request.referrer.split('/').last)
        render :show, status: :unprocessable_entity
        # redirect_to request.referrer, notice: "Can't create duplicate stock"
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
    stock_info = JSON.parse(stock_serialized)
    stock_info.each do |stock|
      if stock["ticker"] == stock_params["ticker"].upcase
        stock["api_id"] = stock.delete("id")
        return stock
      end
    end
  end

  # /stock_news
  def news(stock)
    query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=2022-10-30&sortBy=publishedAt&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    news_hash = JSON.parse(stock_news)
    return news_hash
  end
end
