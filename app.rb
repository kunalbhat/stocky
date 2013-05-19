require 'bundler'

Bundler.require

DataMapper.setup(:default, "sqlite:///#{[Dir.pwd, '/db/stocks.db'].join}")

get '/style.css' do
  scss :style
end

get '/' do
  @symbols = Stock.all

  stocks = []
  StockPrice = Struct.new(:symbol, :price, :change)

  @symbols.each do |symbol|
    symbol = symbol.symbol
    price = MarketBeat.last_trade_real_time symbol
    change_and_percent_change = MarketBeat.change_and_percent_change symbol

    stock = StockPrice.new(symbol, price, change_and_percent_change)
    @stocks = stocks.push(stock)
  end

  haml :show
end

post '/stocks/new' do
  Stock.new(symbol: params[:stock_symbol]).save

  redirect '/'
end

require_relative 'models/stock'
