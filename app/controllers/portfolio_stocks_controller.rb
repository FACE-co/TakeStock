class PortfolioStocksController < ApplicationController
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.find(params[:stock_id])
    @portfolio_stock = PortfolioStock.new
    @portfolio_stock.stock_id = @stock.id
    @portfolio_stock.portfolio = @portfolio
    # save
    if @portfolio_stock.save
      # redirect if successful
      flash.now[:notice] = "Stock saved"
    else
      # render new again if not
      flash.now[:notice] = "Stock already in that portfolio"
    end
  end

  def destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.find(params[:stock_id])
    @portfolio_stock = PortfolioStock.where(["portfolio_id = ? and stock_id = ?", @portfolio.id, @stock.id])
    @portfolio_stock.destroy_all
    # REDIRECT PATH NEEDS CHECKING - CURRENTLY REDIRECTS US TO THE STOCK
    redirect_to root_path, notice: "Stock was successfully deleted."
  end

  private

  def ps_params
    params.require(:portfolio_stock).permit(:portfolio, :portfolio_id, :stock, :stock_id)
  end
end
