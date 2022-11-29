class Stock < ApplicationRecord
  extend FriendlyId
  friendly_id :ticker, use: :slugged
  validates :ticker, uniqueness: true
end
