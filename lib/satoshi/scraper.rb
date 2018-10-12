class Satoshi::Scraper


  def self.scrape_top_100_coins
      doc = Nokogiri::HTML(open("https://coinmarketcap.com/"))
       coin_array = doc.css("tbody tr").each_with_index.map { |coin_container, index|
         name = coin_container.css("a.currency-name-container").text.strip
         price = coin_container.css("a.price").attr("data-usd").value.strip
         puts "#{index + 1}. #{name} $#{price}"
       }

  end
end
