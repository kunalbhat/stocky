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
    data = YahooFinance.quotes([symbol], [:name])

    company = data[0].name.delete! '"'

    @_company ||= company
  end

  def quotes
    @_quotes ||= YahooFinance.historical_quotes([symbol], Time::now-(24*60*60*10), Time::now)
  end

  def status
    point_change.to_f < 0 ? 'loss' : 'gain'
  end

  def point_change
    data = YahooFinance.quotes([symbol], [:change])

    @_point_change ||= data[0].change
  end

  def percent_change
    data = YahooFinance.quotes([symbol], [:change_in_percent])

    @_percent_change ||= data[0].change_in_percent.delete! '"'
  end

  def last_price
    data = YahooFinance.quotes([symbol], [:last_trade_price])

    @_last_trade_price ||= data[0].last_trade_price
  end

  def opening_price
    data = YahooFinance.quotes([symbol], [:open])

    @_opening_price ||= data[0].open
  end
end
