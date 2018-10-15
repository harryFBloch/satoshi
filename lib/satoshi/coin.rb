class Satoshi::Coin
  attr_accessor :percent_change, :btc_price, :usd_market_cap, :btc_market_cap, :volume_usd_24hr, :volume_btc_24hr, :circulating_supply_btc, :max_supply, :info_link, :usd_price, :index, :name
  @@all = []

  def save
    self.class.all << self
  end

  def self.create(name, link, index, price)
    coin = self.new
    coin.name = name
    coin.info_link = link
    coin.index = index
    coin.usd_price = price
    coin.save
  end

  def self.all
    @@all
  end
end
