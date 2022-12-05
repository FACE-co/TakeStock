class TweetsController < ApplicationController
  def index
    @stock = Stock.friendly.find(params[:stock_id])
    @tweets = get_tweet_ids(@stock)
  end

  private

  def get_tweet_ids(stock)
    url = URI("https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{ENV['TWITTER_BEARER_TOKEN']}"
    # request["Cookie"] = "guest_id=v1%3A166993649185035697; guest_id_ads=v1%3A166993649185035697; guest_id_marketing=v1%3A166993649185035697; personalization_id=\"v1_RFCmy9nYtnpzm8vj/loxZw==\""

    response = https.request(request).read_body.force_encoding("UTF-8")
    id_array = JSON.parse(response)["data"].map {|hash| hash["id"]}

    return id_array
  end
end
