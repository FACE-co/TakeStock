class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
  end

  # /stocks(.:format)
  def create
    ## TODO RE-ENABLE :PRODUCTION CODE - TO WORK WITH API
    # @new_stock = Stock.new(call_ticker_api(stock_params))

    # Temporary new_stock for local/testing
    @new_stock = Stock.new(params[:id])
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
end
