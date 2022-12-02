require 'open-uri'
require 'net/http'
require 'openssl'
require 'json'
require 'pry-byebug'
require 'restclient'
require 'rubygems'

require 'yaml'
# require 'net-https'

# need to loop through article ids and call the api again to get article info

# url = URI("https://medium2.p.rapidapi.com/article/464ee17f2256")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true
# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# request = Net::HTTP::Get.new(url)
# request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
# request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

# response = http.request(request)

# article_info = JSON.parse(response.body)
# puts article_info


# def get_article_ids(stock)
#   url = URI("https://medium2.p.rapidapi.com/topfeeds/#{stock}/hot")
#   # http = Net::HTTP.new(url.host, url.port)
#   # http.use_ssl = true
#   # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

#   # request = Net::HTTP::Get.new(url)
#   # request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
#   # request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

#   # response = http.request(request)
#   articles_hash = JSON.parse(response.body)
#   byebug

#   articles = articles_hash["topfeeds"]
#   results = []

#   articles.each do |article|
#     # byebug
#     # results << get_article_info(article)
#     get_article_info(article)
#   end
#   return results
# end

# def get_article_info(article)
#   url = URI("https://medium2.p.rapidapi.com/article/#{article}")

#   http = Net::HTTP.new(url.host, url.port)
#   http.use_ssl = true
#   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

#   request = Net::HTTP::Get.new(url)
#   request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
#   request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

#   response = http.request(request)

#   article_info = JSON.parse(response.body)
#   byebug
#   return article_info
#   # return article_info if article_info["lang"] == "en"
# end

# puts get_article_ids('tsla')
# def get_reddit_articles(stock)
#   query = "https://www.reddit.com/search.json?q=#{stock.ticker}&t=week&sort=top"
#   info = URI.open(query).read
#   hash = JSON.parse(info)
#   articles = hash['data']['children']

#   return articles
#   #reddit_hash['data']['children'][0]['data']['selftext']
# end

# ## CONTROLLER
# @reddit_articles = get_reddit_articles(@stock)

# ## VIEW
# @reddit_articles.each do |article|
#   article['data']['title']
#   article['data']['selftext']
#   article['data']['subreddit']
# end

# def get_access_token()
#   client_id = "eOaIJSfYUq33vHSLLPclKg"
#   client_secret = "xfn_f-JNfn-8ry_zXbMv1jV81rPfbg"
  # query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=2022-10-30&sortBy=publishedAt&apiKey=#{ENV['NEWS_API_KEY']}"
  # stock_news = URI.open(query).read
  # news_hash = JSON.parse(stock_news)

  # to send the user to the authorization URL
  # url = "https://www.reddit.com/api/v1/authorize?client_id=#{client_id}&response_type=code&
  # state=123&redirect_uri=https://www.takestock.dev/&duration=temporary&scope=read"
  # reddit_articles = URI.open(url).read
  # byebug
  # articles_hash = JSON.parse(reddit_articles)
  # return articles_hash
#   puts "getting reddit access token"
#   begin
#     resp = RestClient::Request.execute(
#       method: :post,
#       url: 'https://www.reddit.com/api/v1/access_token',
#       user: client_id,
#       password: client_secret,
#       payload: 'grant_type=client_credentials'
#     )
#     response = JSON.parse(resp.body)
#     puts response
#     return response['access_token']
#   rescue StandardError => e
#     raise StandardError.new 'Error getting Reddit OAuth2 token.'
#   end
# end

# token = get_access_token()

# def get_reddit_articles(token)

# end

def access_token()
  # get the access token
  begin
    resp = RestClient::Request.execute(
      method: :post,
      url: 'https://www.reddit.com/api/v1/access_token',
      user: 'eOaIJSfYUq33vHSLLPclKg',
      password: 'xfn_f-JNfn-8ry_zXbMv1jV81rPfbg',
      payload: 'grant_type=client_credentials'
    )
    response = JSON.parse(resp.body)
    return response['access_token']
  rescue StandardError => e
    raise StandardError.new 'Error getting Reddit OAuth2 token.'
  end
end

def call(query)
  token = access_token
  begin
    raw = RestClient::Request.execute(
      :method => :get,
      :url => "https://www.reddit.com/search.json?q=#{query}&t=week&sort=top",
      :headers => { Authorization: token }
   )

   # json file of reddit articles
   reddit_hash = JSON.parse(raw)

   # parsed json into ruby hash
   # returns hash of hashes post via ['data']['children']
   articles = reddit_hash['data']['children']
   return articles[0]['data']['title']

  rescue StandardError => e
    raise StandardError.new 'Error getting Reddit articles.'
  end
end

puts call('aapl')
