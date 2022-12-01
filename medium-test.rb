require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'pry-byebug'
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


def get_article_ids(stock)
  url = URI("https://medium2.p.rapidapi.com/topfeeds/#{stock}/hot")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
  request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

  response = http.request(request)
  articles_hash = JSON.parse(response.body)
  byebug

  articles = articles_hash["topfeeds"]
  results = []

  articles.each do |article|
    # byebug
    # results << get_article_info(article)
    get_article_info(article)
  end
  return results
end

def get_article_info(article)
  url = URI("https://medium2.p.rapidapi.com/article/#{article}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
  request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

  response = http.request(request)

  article_info = JSON.parse(response.body)
  byebug
  return article_info
  # return article_info if article_info["lang"] == "en"
end

puts get_article_ids('tesla')
