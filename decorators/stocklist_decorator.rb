class StockListDecorator
  def banner
    now = Time.now.utc

    close = Time.utc(now.year, now.day, now.month, 16)
    open = Time.utc(now.year, now.day, now.month, 8)

    if now > close && now < open
      "<div class='market-status'>Market Closed</div>"
    else
      "<div class='market-status'>Market Open &ndash; #{Time.now}</div>"
    end

  end
end
