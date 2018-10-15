class Satoshi::Cli

  def self.run
    puts "Welcome to Satoshi! Here are the top 100 Coins:"
    self.menu
  end

  def self.menu
    Satoshi::Scraper.scrape_top_100_coins
    Satoshi::Scraper.scrape_info_page("/currencies/bitcoin")
    #list top 100 coins and current price
    #get input 1-10 and prompt user
    #list top 10 coins 1-10 to view info
    #get info from coins page
    #repeat program or exit maybe add refresh method
  end

end
