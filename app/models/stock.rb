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

  def trending
    resp = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.stockgeist.ai/stock/us/hist/message-metrics?symbols=#{self.ticker}&start=2022-12-03T00%3A00&end=2022-12-04T00%3A00&metrics=pos_total_count",
      :headers => {Accept: "application/jsonl",
                  token: "lOvHMrdlqwhHRkVU0UZi3PDUI9njSsPU"}
      )
    response = JSON.parse(resp.body)
    pos_count = response['data'][self.ticker][0]['pos_total_count']
    return pos_count
  end
end
