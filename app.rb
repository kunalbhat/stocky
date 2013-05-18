require 'bundler'

Bundler.require

DataMapper.setup(:default, "sqlite:///#{[Dir.pwd, '/db/stocks.db'].join}")

get '/style.css' do
  scss :style
end

get '/' do
  @quotes = Stock.all
  @stocks = Hash.new

  @quotes.each do |quote|
    symbol = quote.symbol
    price = MarketBeat.last_trade_real_time symbol

    @stocks[symbol] = price
  end

  haml :show
end

require_relative 'models/stock'
