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
    self.sort_all_by_index
  end

  def self.sort_all_by_index
    self.all.sort_by { |coin| coin.index}
  end

  def self.all
    @@all
  end

  def load_info(info_hash)
    info_hash.each {|key, value|
        self.send("#{key}=",value)
     }
     display_info
  end

  def display_info
      puts "#{self.name} = $#{self.usd_price}"
      puts "Price In btc = #{self.btc_price}"
      puts "24hr Percent Change = #{(self.percent_change.to_f * 100).to_i}%"
      puts "Market Cap = $#{self.usd_market_cap} = #{self.btc_market_cap} btc"
      puts "24hr Volume = $#{self.volume_usd_24hr} = #{self.volume_btc_24hr} btc"
      puts "Circulating Supply = #{self.circulating_supply_btc}"
      puts "Max Supply = #{self.max_supply}" if self.max_supply
  end

end
