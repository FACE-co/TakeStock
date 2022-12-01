class Stock < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_many :portfolio_stocks
  has_many :portfolios, through: :portfolio_stocks
  extend FriendlyId
  friendly_id :ticker, use: :slugged
  validates :ticker, uniqueness: true

  before_validation :upcase_ticker

  def upcase_ticker
    self.ticker = self.ticker.upcase
  end
end
