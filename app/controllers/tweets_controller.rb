class TweetsController < ApplicationController
  def index
    @stock = Stock.friendly.find(params[:stock_id])
    @tweets = get_tweet_ids(@stock, 100)
  end

  private

  def get_tweet_ids(stock, max_results)
    url = URI("https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}&max_results=#{max_results}&tweet.fields=public_metrics,lang,entities,referenced_tweets&expansions=author_id&user.fields=public_metrics&sort_order=relevancy")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{ENV['TWITTER_BEARER_TOKEN']}"
    # request["Cookie"] = "guest_id=v1%3A166993649185035697; guest_id_ads=v1%3A166993649185035697; guest_id_marketing=v1%3A166993649185035697; personalization_id=\"v1_RFCmy9nYtnpzm8vj/loxZw==\""

    response = https.request(request).read_body.force_encoding("UTF-8")
    response_json = JSON.parse(response)
    response_array = response_json["data"] # this returns an array of hashes
    filtered_response_array = response_array.select { |e| (e["entities"].nil?) || (e["entities"]["cashtags"].nil? || e["entities"]["cashtags"].count <= 3) && (e["lang"] == "en") && (e["entities"]["urls"].nil?) }
    id_array = filtered_response_array.map { |hash| hash["id"] }

    return [id_array.first(10), filtered_response_array]
  end
end
