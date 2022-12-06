class Stock < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include AlgoliaSearch

  has_many :portfolios, through: :portfolio_stocks
  extend FriendlyId
  friendly_id :ticker, use: :slugged
  validates :ticker, uniqueness: true, presence: true

  before_validation :upcase_ticker
  before_save :trending_count

  algoliasearch do
    # Use all default configuration
  end

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

  def trending_count
    resp = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.stockgeist.ai/stock/us/hist/message-metrics?symbols=#{self.ticker}&start=2022-12-03T00%3A00&end=2022-12-04T00%3A00&metrics=total_count",
      :headers => {Accept: "application/json",
                  Token: "U4BnhJrYhPjUbKABSAiX6eedb0plrAI2"}
      )
    response = JSON.parse(resp.body)
    count = response['data'][self.ticker][0]['total_count']
    self.trending = count
  end
end
