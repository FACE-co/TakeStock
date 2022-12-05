class YahooapiController < ApplicationController
  quote = YahooStock::Quote.new(stock_symbol: stock.ticker)
  quote.results(:to_hash).output
end
