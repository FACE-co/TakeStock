class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]

  def show
    @portfolios = Portfolio.where(user_id: current_user.id) if current_user.present?
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    @basic_info = @stock.basic_info_no_alphavantage

    @reddit_articles = RedditSearch.call(@stock.ticker)
    @date_param = params[:enddate]
    session[:datetime] = params[:enddate]
  end

  # /stocks(.:format)
  def create
    ## TODO RE-ENABLE :PRODUCTION CODE - TO WORK WITH API
    # @new_stock = Stock.new(call_ticker_api(stock_params))

    ## TODO COMMENT BELOW OUT DURING PRODUCTION - USE API CALL METHOD ABOVE
    stock_params[:ticker].upcase!
    @new_stock = Stock.new(stock_params)
    # @new_stock['trending'] = trending_count(stock_params["ticker"])
    if @new_stock.save
      redirect_to stock_path(@new_stock), status: :see_other
    else
      @portfolios = []
      @stock = Stock.find_by(ticker: params[:stock][:ticker]) || Stock.find_by(ticker: request.referrer.split('/').last)
      # social = trending_count(stock_params[:ticker])
    # @stock.update(trending: social)
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
end
