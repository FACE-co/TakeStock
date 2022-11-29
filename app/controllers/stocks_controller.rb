class StocksController < ApplicationController
  APIKEY = "5e7415e46d13ac15a2d4ad0bc1ecb028044b31742dc8eb02630eaee45b3e04b7"
  def show
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
  end

  # /stocks(.:format)
  def create
    @new_stock = Stock.new(call_ticker_api(stock_params))
    if @new_stock.save
      redirect_to stock_path(@new_stock)
    else
      redirect_to root_path, notice: "Can't save duplicate stock"
    end
  end

  # /stocks/:id(.:format)
  def update
  end

  # /stocks/:id(.:format)
  def destroy
  end

  # /stocks/trending(.:format)
  def trending
  end

  def stock_params
    params.require(:stock).permit(:ticker)
  end

  def call_ticker_api(stock_params)
    query = "https://api.sec-api.io/mapping/ticker/#{stock_params[:ticker]}?token=#{APIKEY}"
    stock_serialized = URI.open(query).read
    stock_info = JSON.parse(stock_serialized).first
    stock_info["api_id"] = stock_info.delete("id")
    return stock_info
  end
end
