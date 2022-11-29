class PortfolioStocksController < ApplicationController
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.find(params[:stock_id])
    @portfolio_stock = PortfolioStock.new(ps_params)
    @portfolio_stock.stock = @stock
    @portfolio_stock.portfolio = @portfolio
    # save
    if @portfolio_stock.save
      # redirect if successful
      redirect_to root_path, notice: "Successfully created task", status: :see_other
    else
      # render new again if not
      render :new, status: :unprocessable_entity
    end
  end

  def destroy

  end

  private

  def ps_params
    params.require(:portfolio_stock).permit(:portfolio_id, :stock_id)
  end
end
