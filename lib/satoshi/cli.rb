class Satoshi::Cli
@@selectable_array = []
  def self.run
    puts "Welcome to Satoshi! Here are the top 100 Coins:"
    self.menu
  end

  def self.menu
    self.create_coins(coin_array = Satoshi::Scraper.scrape_top_100_coins)
    self.first_prompt_for_coins
    Satoshi::Scraper.scrape_info_page("/currencies/bitcoin")
    #list top 100 coins and current price
    #get input 1-10 and prompt user
    #list top 10 coins 1-10 to view info
    #get info from coins page
    #repeat program or exit maybe add refresh method
  end

  def self.create_coins(coin_array)
    coin_array.each {|coin_hash| Satoshi::Coin.create(coin_hash[:name], coin_hash[:info_link], coin_hash[:index], coin_hash[:usd_price])}
  end

  def self.first_prompt_for_coins
      puts "enter 1-10 to view the top coins 1 = 1-10 , 2 = 11-20, 3 = 21-30...."
      input = gets.chomp.to_i
      if input > 0 && input < 11
          input -= 1
          lower_range = input * 10
          higher_range = lower_range + 10
          coins_to_print = Satoshi::Coin.all[lower_range...higher_range]
          self.selectable_array = coins_to_print
          coins_to_print.each {|coin| puts"#{coin.index}. #{coin.name} $#{coin.usd_price}"}
          self.get_info_for_coin
      else
        puts "Invalid argument, please try again"
        self.first_prompt_for_coins
      end
  end

  def self.get_info_for_coin
    puts "Enter 1-10 to view coin info"
    input = gets.chomp.to_i
    if input <= 10 && input > 0
      coin = self.selectable_array[input - 1]
      coin.load_info(Satoshi::Scraper.scrape_info_page(coin.info_link))
    elsif input.to_s == "exit"
      self.exit
    else
      self.get_info_for_coin
    end
  end

  def self.selectable_array=(array)
    @@selectable_array = array
  end

  def self.selectable_array
    @@selectable_array
  end

end
