class PortfolioStocksController < ApplicationController
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.find(params[:stock_id])
    @portfolio_stock = PortfolioStock.new
    @portfolio_stock.stock_id = @stock.id
    @portfolio_stock.portfolio = @portfolio
    # save
    if @portfolio_stock.save
      flash.now[:notice] = "Stock is saved to your portfolio #{@portfolio.name}!"
      # respond_to do |format|
      #   format.html { redirect_to request.referer, notice: "Stock is saved to your portfolio #{@portfolio.name}!" }
      # end
    else
      flash.now[:notice] = 'Stock already in that portfolio.'
      # respond_to do |format|
      #   format.html { redirect_to request.referer, notice: 'Stock already in that portfolio.' }
      # end
    end
  end

  def destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
    @stock = Stock.find(params[:stock_id])
    @portfolio_stock = PortfolioStock.where(["portfolio_id = ? and stock_id = ?", @portfolio.id, @stock.id])
    @portfolio_stock.destroy_all
    # REDIRECT PATH NEEDS CHECKING - CURRENTLY REDIRECTS US TO THE STOCK
    redirect_to root_path, notice: "#{@stock.name} was successfully deleted from #{@portfolio.name}."
  end

  private

  def ps_params
    params.require(:portfolio_stock).permit(:portfolio, :portfolio_id, :stock, :stock_id)
  end
end
