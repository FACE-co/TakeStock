class TweetsController < ApplicationController
  def index
    @stock = Stock.friendly.find(params[:stock_id])

    # heroku production server use this heroku = GMT, Twitter = UTC (same...?)
    # @date_param = [(Date.parse(params[:enddate]).to_time - 24*60*60).utc.iso8601, Date.parse(params[:enddate]).to_time.utc.iso8601]

    # localhost melb use this (+11h UTC)
    @date_param = [(Date.parse(params[:enddate]).to_time - 35*60*60).utc.iso8601, (Date.parse(params[:enddate]).to_time - 11*60*60).utc.iso8601]

    @tweets = get_tweet_ids(@stock, 100)
    # 2022-12-01T04:42:30.000Z
  end

  private

  def get_tweet_ids(stock, max_results)
    url = URI("https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}&max_results=#{max_results}&tweet.fields=public_metrics,lang,entities,referenced_tweets&expansions=author_id&sort_order=recency&start_time=#{@date_param[0]}&end_time=#{@date_param[1]}")
    # url = URI("https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}&max_results=#{max_results}&tweet.fields=public_metrics,lang,entities,referenced_tweets&sort_order=relevancy")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{ENV['TWITTER_BEARER_TOKEN']}"
    # request["Cookie"] = "guest_id=v1%3A166993649185035697; guest_id_ads=v1%3A166993649185035697; guest_id_marketing=v1%3A166993649185035697; personalization_id=\"v1_RFCmy9nYtnpzm8vj/loxZw==\""

    response = https.request(request).read_body.force_encoding("UTF-8")
    response_json = JSON.parse(response)
    response_array = response_json["data"]

    if response_array.present?
      response_array_unique_authors = response_array.uniq { |tweet| tweet["text"] }
      filter_only_en = response_array_unique_authors.select { |tweet| tweet["lang"] == "en" }
      filter_no_entities_then_no_spam = filter_only_en.select { |tweet|  (tweet["entities"].nil?) || ((tweet["entities"]["cashtags"].nil? || tweet["entities"]["cashtags"].count <= 3) && (tweet["entities"]["urls"].nil?)) }
      id_array = filter_no_entities_then_no_spam.map { |hash| hash["id"] }
      return [id_array.first(10), filter_no_entities_then_no_spam]
    else
      return [["20"], {nothing: "here"}]
    end
  end
end

# https://api.twitter.com/2/tweets/search/recent?query=aapl&start_time=2022-12-01T04:42:30.000Z&end_time=2022-12-05T04:42:30.000Z&max_results=20&tweet.fields=created_at&sort_order=relevancy
# https://api.twitter.com/2/tweets/search/recent?query=#{stock.ticker}&max_results=#{max_results}&tweet.fields=public_metrics,lang,entities,referenced_tweets&sort_order=recency&start_time=#{(DateTime.current.to_date-6)}T00:00:00.000Z&end_time=#{@date_param}T00:00:00.000Z


# &expansions=author_id&user.fields=public_metrics
