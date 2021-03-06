require 'json'
require 'yahoo_finance'

Bundler.require :web
Bundler.require :development if development?

require_relative 'services/stock_info'
require_relative 'decorators/stocklist_decorator'

use Rack::Coffee, root: 'assets', urls: '/javascripts'

get '/style.css' do
  scss :style
end

get '/' do
  haml :index
end

get '/portfolio' do
  @decorator = StockListDecorator.new

  haml :portfolio
end

post '/search' do
  @symbol = StockInfo.new(params[:stock_symbol])

  haml :symbol
end

get '/stocks' do
  content_type :json
  StockInfo.new(params[:symbol]).to_hash.to_json
end

get '/:symbol' do
  @symbol = StockInfo.new(params[:symbol])

  haml :symbol
end

delete '/stocks/:id' do |id|
  if stock = Stock.get(params[:id])
    stock.destroy
  end
end

not_found do
  haml :'404'
end
