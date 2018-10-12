class Satoshi::Scraper
  COIN_MARKET_CAP_URL = "https://coinmarketcap.com/"

  def self.scrape_top_100_coins
      doc = Nokogiri::HTML(open(COIN_MARKET_CAP_URL))
       coin_array = doc.css("tbody tr").each_with_index.map { |coin_container, index|
         name = coin_container.css("a.currency-name-container").text.strip
         link = coin_container.css("a.currency-name-container").attr("href").value
         price = coin_container.css("a.price").attr("data-usd").value.strip
         #puts "#{index + 1}. #{name}-$#{price}"
         coin_hash = {:name => name, :price => price,:index => index + 1 , :link => link}
       }
  end
end
