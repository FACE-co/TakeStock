class Stock < ApplicationRecord
  has_many :portfolio_stocks
  has_many :portfolios, through: :portfolio_stocks
end
