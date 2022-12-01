class StocksController < ApplicationController
  def show
    @portfolios = Portfolio.where(user_id: current_user.id)
    @stock = Stock.friendly.find(params[:id])
    @new_stock = Stock.new
    # @news_hash = news(@stock)
    @medium_articles = get_articles('tesla')
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

  def get_articles(stock)
    # url = URI("https://medium2.p.rapidapi.com/topfeeds/#{stock.ticker}+stock/new")
    url = URI("https://medium2.p.rapidapi.com/topfeeds/#{stock}/new")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = 'f7ec49b0abmshdcd8f7286f9abd2p1b5af4jsn9353c237af81'
    request["X-RapidAPI-Host"] = 'medium2.p.rapidapi.com'

    response = http.request(request)
    articles_hash = JSON.parse(response.body)
    results = []

    articles_hash["topfeeds"].each do |article|
      results << get_article_info(article)
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
    # return article_info if article_info["lang"] == "en"
    return article_info
  end
end
