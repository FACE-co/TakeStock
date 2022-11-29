class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.find(user_id: current_user.id)
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
