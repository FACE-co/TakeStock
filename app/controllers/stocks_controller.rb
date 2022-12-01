class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    # @news_hash = news(@stock)
    @reddit_articles = get_reddit_articles(@stock)
  end

  # /stocks(.:format)
  def create
    ## TODO RE-ENABLE :PRODUCTION CODE - TO WORK WITH API
    # @new_stock = Stock.new(call_ticker_api(stock_params))

    ## TODO COMMENT BELOW OUT DURING PRODUCTION - USE API CALL METHOD ABOVE
    @new_stock = Stock.new(stock_params)
    if @new_stock.save
      redirect_to stock_path(@new_stock), status: :see_other
    else
      @portfolios = []
      @stock = Stock.find_by(ticker: params[:stock][:ticker]) || Stock.find_by(ticker: request.referrer.split('/').last)
      render :show, status: :unprocessable_entity
      # redirect_to request.referrer, notice: "Can't create duplicate stock"
    end
  end

  # /stocks/:id(.:format)
  def update
    @stock = Stock.friendly.find(params[:id])
    if @stock.update(call_ticker_api(stock_params))
      redirect_to stock_path(@stock)
    else
      redirect_to root_path, notice: "Can't update"
    end
  end

  # /stocks/:id(.:format)
  def destroy
    @stock = Stock.friendly.find(params[:id])
    @stock.destroy
  end

  # /stocks/trending(.:format)
  def trending
  end

  private

  def stock_params
    params.require(:stock).permit(:ticker)
  end

  def call_ticker_api(stock_params)
    query = "https://api.sec-api.io/mapping/ticker/#{stock_params[:ticker]}?token=#{ENV['SEC_API_KEY']}"
    stock_serialized = URI.open(query).read
    stock_info = JSON.parse(stock_serialized)
    stock_info.each do |stock|
      if stock["ticker"] == stock_params["ticker"].upcase
        stock["api_id"] = stock.delete("id")
        return stock
      end
    end
  end

  # /stock_news
  def news(stock)
    query = "https://newsapi.org/v2/everything?q=#{stock.ticker}&from=2022-10-30&sortBy=publishedAt&apiKey=#{ENV['NEWS_API_KEY']}"
    stock_news = URI.open(query).read
    news_hash = JSON.parse(stock_news)
    return news_hash
  end

  def get_reddit_articles(stock)
    ## the app should make a request to the following endpoint to retrieve your access token:
    #https://www.reddit.com/api/v1/access_token

    DEVICE_ID = "eOaIJSfYUq33vHSLLPclKg"
    ## When using the https://oauth.reddit.com/grants/installed_client grant, include the following information in your POST data:
    grant_type=https://oauth.reddit.com/grants/installed_client&\
    device_id=DEVICE_ID

    client_secret = "xfn_f-JNfn-8ry_zXbMv1jV81rPfbg"

    user: client_id
    password: client_secret

    open("https://oauth.reddit.com/grants/installed_client", http_basic_authentication:["user", "password"])

    query = "https://www.reddit.com/search.json?q=#{stock.ticker}&t=week&sort=top"
    info = URI.open(query).read
    hash = JSON.parse(info)
    articles = hash['data']['children']

    return articles
    #hash['data']['children'][0]['data']['selftext']
  end

  def get_access_token()
    puts "getting reddit access token"
    begin
      resp = RestClient::Request.execute(
        method: :post,
        url: 'https://www.reddit.com/api/v1/access_token',
        user: @client_id,
        password: @client_secret,
        payload: 'grant_type=client_credentials'
      )
      response = JSON.parse(resp.body)
      response['access_token']
    rescue StandardError => e
      raise StandardError.new 'Error getting Reddit OAuth2 token.'
    end
  end
end
