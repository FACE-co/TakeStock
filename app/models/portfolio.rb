class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :portfolio_stocks
  has_many :stocks, through: :portfolio_stocks
end
