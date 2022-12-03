class PortfoliosController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]

  def show
    @portfolio = Portfolio.find(params[:id])
    @portfolio_stocks = PortfolioStock.where(portfolio_id: @portfolio.id)
    @stocks = Stock.where(id: @portfolio_stocks.map(&:id))
    @portfolios = Portfolio.where(user: current_user)
  end

  # /portfolios/:id
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
    @portfolio = Portfolio.find(params[:id])
    if @Portfolio.update(portfolio_params)
      redirect_to root_path, notice: "Portfolio name was successfully updated."
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def destroy
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy
    redirect_to root_path, notice: "Portfolio was successfully destroyed."
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:name, :user_id)
  end
end
