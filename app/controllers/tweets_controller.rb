class TweetsController < ApplicationController
  def index
    @stock = Stock.friendly.find(params[:id])
    @tweets = get_tweet_ids(@stock)
  end

  private

  def get_tweet_ids(stock)
    query = "https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}"
    query_serialized = URI.open(query).read
    query_parsed = JSON.parse(query_serialized)


  end
end
