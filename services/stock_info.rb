require 'date'

class StockInfo
  attr_accessor :symbol

  def initialize(symbol)
    self.symbol = symbol
  end

  def last_prices
    quotes.map { |quote| quote[:close].to_f }
  end

  def last_prices_days
    quotes.map { |quote| quote[:date].strftime("%a") }
  end

  def to_hash
    { company:        company,
      last_price:     last_price,
      opening_price:  opening_price,
      point_change:   point_change,
      percent_change: percent_change,
      quotes:         quotes,
      status:         status,
      symbol:         symbol }
  end

  def company
    @_company ||= MarketBeat.company symbol
  end

  def quotes
    today          = Date.today
    start_of_week  = today - 5

    @_quotes ||= MarketBeat.quotes(symbol, start_of_week, today)
  end

  def status
    point_change.to_f < 0 ? 'loss' : 'gain'
  end

  def point_change
    change_and_percent_change.first
  end

  def percent_change
    change_and_percent_change.last
  end

  def last_price
    @_last_trade_price ||= MarketBeat.last_trade_real_time symbol
  end

  def opening_price
    @_opening_price ||= MarketBeat.opening_price symbol
  end

  private

  def change_and_percent_change
    @_change_and_percent_change ||= MarketBeat.change_and_percent_change symbol
  end
end
