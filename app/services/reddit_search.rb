class RedditSearch < ApplicationService

  def initialize(query)
    @query = query
  end

  # get the access token
  def access_token
    begin
      resp = RestClient::Request.execute(
        method: :post,
        url: 'https://www.reddit.com/api/v1/access_token',
        user: ENV['REDDIT_CLIENT_ID'],
        password: ENV['REDDIT_CLIENT_SECRET'],
        payload: 'grant_type=client_credentials'
      )
      response = JSON.parse(resp.body)
      return response['access_token']
    rescue StandardError => e
      raise StandardError.new 'Error getting Reddit OAuth2 token.'
    end
  end

  def call
    token = access_token
    begin
      raw = RestClient::Request.execute(
        :method => :get,
        :url => "https://www.reddit.com/search.json?q=#{@query}&t=week&sort=top",
        :headers => { Authorization: token }
     )

     # json file of reddit articles
     reddit_hash = JSON.parse(raw)

     # parsed json into ruby hash
     # returns hash of hashes post via ['data']['children']
     articles = reddit_hash['data']['children']
     return articles

    rescue StandardError => e
      raise StandardError.new 'Error getting Reddit articles.'
    end
  end
end
