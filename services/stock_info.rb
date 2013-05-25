class StockInfo
  attr_accessor :symbol

  def initialize(symbol)
    self.symbol = symbol
  end

  def to_hash
    { symbol:         symbol,
      last_price:     last_price,
      opening_price:  opening_price,
      ticker_trend:   ticker_trend,
      point_change:   point_change,
      percent_change: percent_change,
      chart_url:      chart_url,
      status:         status }
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

  def chart_url
    @_chart_url ||= MarketBeat.chart_url symbol
  end

  def ticker_trend
    @_ticker_trend ||= MarketBeat.ticker_trend symbol
  end

  private

  def change_and_percent_change
    @_change_and_percent_change ||= MarketBeat.change_and_percent_change symbol
  end
end
