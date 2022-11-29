class Stock < ApplicationRecord
  has_many :portfolio_stocks
  has_many :portfolios, through: :portfolio_stocks
  extend FriendlyId
  friendly_id :ticker, use: :slugged
end
