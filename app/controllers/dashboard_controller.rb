class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @portfolios = Portfolio.where(user: current_user).order(:created_at)
    if params[:query].present?
      @stocks = Stock.search_by_name_and_ticker_and_sector(params[:query])
    else
      @stocks = Stock.all
    end
  end
end
