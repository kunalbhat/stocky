require 'bundler'

Bundler.require

DataMapper.setup(:default, "sqlite:///#{[Dir.pwd, '/db/stocks.db'].join}")

get '/style.css' do
  scss :style
end

get '/' do
  @symbols = Stock.all

  stocks = []
  StockPrice = Struct.new(:id, :symbol, :price, :change, :opening_price, :notes)

  @symbols.each do |symbol|
    id = symbol.id
    symbol = symbol.symbol
    price = MarketBeat.last_trade_real_time symbol
    change_and_percent_change = MarketBeat.change_and_percent_change symbol
    opening_price = MarketBeat.opening_price symbol
    notes = MarketBeat.ticker_trend symbol

    stock = StockPrice.new(id, symbol, price, change_and_percent_change, opening_price, notes)
    @stocks = stocks.push(stock)
  end

  haml :show
end

post '/stocks/new' do
  Stock.new(symbol: params[:stock_symbol]).save

  redirect '/'
end

delete '/stocks/:id' do |id|
  if stock = Stock.get(params[:id].to_i)
    stock.destroy
  end
end

require_relative 'models/stock'
