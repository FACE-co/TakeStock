class PortfolioStock < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  validates :portfolio, uniqueness: { scope: :stock }
end
