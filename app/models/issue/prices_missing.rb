class Issue::PricesMissing < Issue
  store_accessor :data, :missing_prices

  validates :missing_prices, presence: true

  def append_missing_price(ticker, date)
    missing_prices[ticker] ||= []
    missing_prices[ticker] << date
  end

  def stale?
    stale = true
    missing_prices.each do |ticker, dates|
      oldest_date = dates.min
      expected_price_count = (oldest_date..Date.current).count
      prices = Security::Price.find_prices(ticker: ticker, start_date: oldest_date)
      stale = false if prices.count < expected_price_count
    end

    stale
  end
end