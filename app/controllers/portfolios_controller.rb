class PortfoliosController < ApplicationController
  def show
    @portfolio = Portfolio.find(params[:id])
    @portfolio_stocks = PortfolioStock.where(portfolio_id: @portfolio.id)
    @stocks = Stock.where(id: @portfolio_stocks.map(&:id))
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user = current_user

    if @portfolio.save
      redirect_to root_path, status: :see_other
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def update

  end

  def destroy
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end
end
