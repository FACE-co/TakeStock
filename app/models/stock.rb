class Stock < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  # include AlgoliaSearch
  include PgSearch::Model

  has_many :portfolios, through: :portfolio_stocks
  extend FriendlyId
  friendly_id :ticker, use: :slugged
  validates :ticker, uniqueness: true

  before_validation :upcase_ticker

  # algoliasearch per_environment: true do # index name will be "Stock_#{Rails.env}"
  #   attribute :name, :ticker, :sector
  #   add_attribute :yahooapi
  # end

  pg_search_scope :search_by_name_and_ticker_and_sector,
    against: [ :name, :ticker, :sector ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }


  def upcase_ticker
    self.ticker = self.ticker.upcase
  end

  def basic_info
    api_key = "R4E0Q2VIZSLUWL6Q"

    # getting fundamental data
    query_fundamental = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{self.ticker}&apikey=#{api_key}"
    stock_fundamental = URI.open(query_fundamental).read
    stock_fundamental_hash = JSON.parse(stock_fundamental)

    # getting daily price data
    query_daily = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=#{self.ticker}&apikey=#{api_key}"
    stock_daily = URI.open(query_daily).read
    stock_daily_hash = JSON.parse(stock_daily)
    stock_daily_hash_only_first_two_days = stock_daily_hash["Time Series (Daily)"].first(2).to_h
    stock_today = stock_daily_hash_only_first_two_days.first[1]

    # calculating change and change%
    stock_today_close = stock_daily_hash_only_first_two_days.values[0]["4. close"].to_f
    stock_yesterday_close = stock_daily_hash_only_first_two_days.values[1]["4. close"].to_f
    change = stock_yesterday_close - stock_today_close
    change_percentage = change / stock_yesterday_close

    # making change/change% a hash
    temp_hash = {}
    temp_hash["change"] = "#{change.round(2)}"
    temp_hash["change%"] = "#{change_percentage.round(2)}%"

    final_hash = stock_fundamental_hash.merge(stock_today).merge(temp_hash)

    return final_hash
  end

  def yahooapi
    query = BasicYahooFinance::Query.new
    data = query.quotes(self.ticker)
    return data["#{self.ticker}"]
  end
end
