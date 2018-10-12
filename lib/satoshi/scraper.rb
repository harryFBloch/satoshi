class Satoshi::Scraper


  def scrape_top_100_coins
      doc = Nokogiri::Html(open(https://coinmarketcap.com/))
      binding.pry
  end
end
