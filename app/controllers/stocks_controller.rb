class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    # @news_hash = news(@stock, @enddate)
    @basic_info = basic_info(@stock)
  end

  # /stocks(.:format)
  def create
    ## TODO RE-ENABLE :PRODUCTION CODE - TO WORK WITH API
    # @new_stock = Stock.new(call_ticker_api(stock_params))

    ## TODO COMMENT BELOW OUT DURING PRODUCTION - USE API CALL METHOD ABOVE
    stock_params[:ticker].upcase!
    @new_stock = Stock.new(stock_params)
    if @new_stock.save
      redirect_to stock_path(@new_stock), status: :see_other
    else
      @portfolios = []
      @stock = Stock.find_by(ticker: params[:stock][:ticker]) || Stock.find_by(ticker: request.referrer.split('/').last)
      @news_hash = {}
      @basic_info = {}
      # render :show, status: :unprocessable_entity
      redirect_to stock_path(@stock), status: :see_other
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
  def news(stock, enddate)
    query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=#{enddate}&sortBy=publishedAt&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    news_hash = JSON.parse(stock_news)
    return news_hash
  end

  def basic_info(stock)
    api_key = "R4E0Q2VIZSLUWL6Q"

    # getting fundamental data
    query_fundamental = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{stock.ticker}&apikey=#{api_key}"
    stock_fundamental = URI.open(query_fundamental).read
    stock_fundamental_hash = JSON.parse(stock_fundamental)

    # getting daily price data
    query_daily = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=#{stock.ticker}&apikey=#{api_key}"
    stock_daily = URI.open(query_daily).read
    stock_daily_hash = JSON.parse(stock_daily)
    stock_daily_hash_only_first_two_days = stock_daily_hash["Time Series (Daily)"].first(2).to_h
    stock_today = stock_daily_hash_only_first_two_days.first[1]

    # calculating change and change%
    stock_today_close = stock_daily_hash_only_first_two_days.values[0]["4. close"].to_f
    stock_yesterday_close = stock_daily_hash_only_first_two_days.values[1]["4. close"].to_f
    change = stock_yesterday_close - stock_today_close
    change_percentage = change / stock_yesterday_close

    # making change/change% a hash
    temp_hash = {}
    temp_hash["change"] = "#{change.round(2)}"
    temp_hash["change%"] = "#{change_percentage.round(2)}%"

    final_hash = stock_fundamental_hash.merge(stock_today).merge(temp_hash)

    return final_hash
  end
end
