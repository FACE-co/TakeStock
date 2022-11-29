class StocksController < ApplicationController
  def show
    @stock = Stock.friendly.find(params[:id])
  end

  def create
  end

  def update
  end

  def destroy
  end

  def trending
  end
end
