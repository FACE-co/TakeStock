class Stock < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  # include AlgoliaSearch
  include PgSearch::Model

  has_many :portfolios, through: :portfolio_stocks
  extend FriendlyId
  friendly_id :ticker, use: :slugged
  validates :ticker, uniqueness: true, presence: true

  before_validation :upcase_ticker
  # before_save :trending_count

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

    # concatenating all hashes
    final_hash = stock_fundamental_hash.merge(stock_today).merge(temp_hash)

    return final_hash
  end

  def basic_info_no_alphavantage
    query = BasicYahooFinance::Query.new
    data = query.quotes(self.ticker)
    data_final = data["#{self.ticker}"]

    if data_final.present?
      hash = {
        regularMarketOpen: data_final["regularMarketOpen"].present? ? data_final["regularMarketOpen"].round(2) : "-",
        regularMarketChange: data_final["regularMarketChange"].present? ? data_final["regularMarketChange"].round(2) : "-",
        marketCap: data_final["marketCap"].present? ? data_final["marketCap"] : "-",
        regularMarketDayHigh: data_final["regularMarketDayHigh"].present? ? data_final["regularMarketDayHigh"].round(2) : "-",
        regularMarketChangePercent: data_final["regularMarketChangePercent"].present? ? data_final["regularMarketChangePercent"].round(2) : "-",
        fullExchangeName: data_final["fullExchangeName"].present? ? data_final["fullExchangeName"] : "-",
        regularMarketDayLow: data_final["regularMarketDayLow"].present? ? data_final["regularMarketDayLow"].round(2) : "-",
        fiftyTwoWeekHigh: data_final["fiftyTwoWeekHigh"].present? ? data_final["fiftyTwoWeekHigh"].round(2) : "-",
        epsTrailingTwelveMonths: data_final["epsTrailingTwelveMonths"].present? ? data_final["epsTrailingTwelveMonths"].round(2) : "-",
        regularMarketPreviousClose: data_final["regularMarketPreviousClose"].present? ? data_final["regularMarketPreviousClose"].round(2) : "-",
        fiftyTwoWeekLow: data_final["fiftyTwoWeekLow"].present? ? data_final["fiftyTwoWeekLow"].round(2) : "-",
        trailingPE: data_final["trailingPE"].present? ? data_final["trailingPE"].round(2) : "-",
        regularMarketVolume: data_final["regularMarketVolume"].present? ? data_final["regularMarketVolume"] : "-",
        trailingAnnualDividendRate: data_final["trailingAnnualDividendRate"].present? ? data_final["trailingAnnualDividendRate"].round(2) : "-",
        sharesOutstanding: data_final["sharesOutstanding"].present? ? data_final["sharesOutstanding"] : "-"
      }
    else
      hash = {
        regularMarketOpen: "-",
        regularMarketChange: "-",
        marketCap: "-",
        regularMarketDayHigh: "-",
        regularMarketChangePercent: "-",
        fullExchangeName: "-",
        regularMarketDayLow: "-",
        fiftyTwoWeekHigh: "-",
        epsTrailingTwelveMonths: "-",
        regularMarketPreviousClose: "-",
        fiftyTwoWeekLow: "-",
        trailingPE: "-",
        regularMarketVolume: "-",
        trailingAnnualDividendRate: "-",
        sharesOutstanding: "-"
      }
    end

    return hash
  end

  def yahooapi
    query = BasicYahooFinance::Query.new
    data = query.quotes(self.ticker)
    data_final = data["#{self.ticker}"]
    if data_final.present?
      return data_final
    else
      return "nothing here"
    end
  end

  def trending_count
    resp = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.stockgeist.ai/stock/us/hist/message-metrics?symbols=#{self.ticker}&start=2022-12-03T00%3A00&end=2022-12-04T00%3A00&metrics=total_count",
      :headers => {Accept: "application/json",
                  #Token: "U4BnhJrYhPjUbKABSAiX6eedb0plrAI2"
                }
      )
    response = JSON.parse(resp.body)
    count = response['data'][self.ticker][0]['total_count']
    self.trending = count
  end
end
