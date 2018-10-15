class Satoshi::Scraper
  COIN_MARKET_CAP_URL = "https://coinmarketcap.com/"

  def self.scrape_top_100_coins
      doc = Nokogiri::HTML(open(COIN_MARKET_CAP_URL))
       coin_array = doc.css("tbody tr").each_with_index.map { |coin_container, index|
         name = coin_container.css("a.currency-name-container").text.strip
         link = coin_container.css("a.currency-name-container").attr("href").value
         price = coin_container.css("a.price").attr("data-usd").value.strip
         #puts "#{index + 1}. #{name}-$#{price}"
         coin_hash = {:name => name, :usd_price => price,:index => index + 1 , :info_link => link}
       }
  end

  def self.scrape_info_page(url)
    doc = Nokogiri::HTML(open(COIN_MARKET_CAP_URL + url))
    info_hash = {}
    info_hash[:percent_change] = doc.css(".details-panel-item--price .h2 span").text
    info_hash[:btc_price] = doc.css(".details-panel-item--price .text-gray span").text.strip
    market_cap_array = doc.css("div.coin-summary-item")

    market_cap_array.each {|coin_container|
      price_type = coin_container.css("h5.coin-summary-item-header").text
      case price_type
      when "Market Cap"
        info_hash[:usd_market_cap] = coin_container.css("div.coin-summary-item-detail span span")[0].text
        info_hash[:btc_market_cap] = coin_container.css("div.coin-summary-item-detail span span")[2].text.gsub("\n", "")
      when "Volume (24h)"
        info_hash[:volume_usd_24hr] = coin_container.css("div.coin-summary-item-detail span span")[0].text
        info_hash[:volume_btc_24hr] = coin_container.css("div.coin-summary-item-detail span span")[2].text.gsub("\n", "")
      when "Circulating Supply"
        info_hash[:circulating_supply_btc] = coin_container.css("div.coin-summary-item-detail span").text.strip
      when "Max Supply"
        info_hash[:max_supply] = coin_container.css("div.coin-summary-item-detail span").text.strip
      end
    }
  end
end
