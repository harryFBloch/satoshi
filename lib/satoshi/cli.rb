class Satoshi::Cli

@@selectable_array = []

  def self.run
    puts "Welcome to Satoshi! Here you can find info on the top 100 Coins:"
    self.menu
  end

  def self.menu
    self.create_coins(coin_array = Satoshi::Scraper.scrape_top_100_coins)
    self.first_prompt_for_coins
  end

  def self.create_coins(coin_array)
    coin_array.each {|coin_hash| Satoshi::Coin.create(coin_hash[:name], coin_hash[:info_link], coin_hash[:index], coin_hash[:usd_price])}
  end

  def self.first_prompt_for_coins
      puts "-------------------------"
      puts "enter 1-10 to view the top coins 1 = 1-10 , 2 = 11-20, 3 = 21-30...."
      puts "or enter the name of the coin you wish to view"
      puts "-------------------------"
      input = gets.chomp
      #binding.pry
      self.exit if input == "exit"
      coin = Satoshi::Coin.find_by_name(input)
      #binding.pry
      if coin
        coin.load_info(Satoshi::Scraper.scrape_info_page(coin.info_link))
        self.info_menu(coin)
      end
      input = input.to_i unless input == "exit"
      if input > 0 && input < 11
          input -= 1
          lower_range = input * 10
          higher_range = lower_range + 10
          coins_to_print = Satoshi::Coin.all[lower_range...higher_range]
          self.selectable_array = coins_to_print
          puts "-------------------------"
          coins_to_print.each {|coin| puts"#{coin.index}. #{coin.name} $#{coin.usd_price}"}
          puts "-------------------------"
          self.get_info_for_coin
      else
        #binding.pry
        puts "Invalid argument, please try again!".red
        self.first_prompt_for_coins
      end
  end

  def self.get_info_for_coin
    puts "Enter 1-10 to view coin info"
    input = gets.chomp
    return self.exit if input == "exit"
    input = input.to_i
    if input <= 10 && input > 0
      coin = self.selectable_array[input - 1]
      coin.load_info(Satoshi::Scraper.scrape_info_page(coin.info_link))
      self.info_menu(coin)
    else
      puts "Invalid argument please try again!".red
      self.get_info_for_coin
    end
  end

  def self.info_menu(coin)
    puts "-------------------------"
    puts "You are looking at #{coin.name}"
    puts "Enter graph ,social, search, ticker, add, delete, or exit:"
    input = gets.chomp
    case input
    when "graph"
      type = self.graph_type_from_coin(coin)
      timespan = self.graph_timeframe_from_coin(coin)
      Satoshi::Graph.createGraphForCoin(coin.ticker, type, timespan)
      self.info_menu(coin)
    when "social"

    when "ticker"
      Satoshi::Ticker.coin_array << coin unless Satoshi::Ticker.coin_array.find {|fcoin| fcoin == coin}
      Satoshi::Ticker.ticker_for_coin_array(coin)
    when "add"
      Satoshi::Ticker.coin_array << coin unless Satoshi::Ticker.coin_array.find {|fcoin| fcoin == coin}
      puts "coin has been added to ticker..You can add multiple coins to the ticker!".green
      self.info_menu(coin)
    when "delete"
      Satoshi::Ticker.coin_array.delete_if {|dcoin| dcoin == coin}
      puts "coin has been removed from ticker".red
      self.info_menu(coin)
    when "search"
      self.first_prompt_for_coins
    when "exit"
      self.exit
    else
      puts  "Invalid argument please try again!".red
      self.info_menu(coin)
    end

  end

  def self.graph_type_from_coin(coin)
    puts "Would You Like to see a (c)candlestick or (l)line graph?"
    input_type = gets.chomp
    type = ""
    case input_type
    when "c"
      type = "candlestick"
    when "l"
      type = "dark"
    when "exit"
      self.exit
    else
        puts  "Invalid argument please try again!".red
        self.graph_coin(coin)
    end
    type
  end

  def self.graph_timeframe_from_coin(coin)
    puts "What time span would you like the graph to be?"
    puts "Enter: 1y, 30d, 7d, or 24h"
    timespan = gets.chomp
    if timespan == "1y" || timespan == "30d" || timespan == "7d" || timespan == "24h"
      timespan
    elsif timespan == "exit"
      self.exit
    else
      puts  "Invalid argument please try again!".red
      self.graph_timeframe_from_coin(coin)
    end
  end

  def self.selectable_array=(array)
    @@selectable_array = array
  end

  def self.selectable_array
    @@selectable_array
  end

  def self.exit
    puts "-------------------------"
    abort("Goodbye")
  end

end
