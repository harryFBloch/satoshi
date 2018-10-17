class Satoshi::Ticker
  require "timeout"

@@stop_bool = false
@@input = " "
@@coin_array = []

  # def self.ticker_for_coin(coin)
  #     puts "press control + c to stop"
  #     puts "-------------------------"
  #     puts "-------------------------"
  #       #Timeout::timeout(20) do
  #         self.get_and_display_price(coin)
  #         self.input = gets.chomp.to_s
  #         case self.input
  #         when "exit"
  #           Satoshi::Cli.exit
  #         when "search"
  #           self.stop_bool = true
  #         when "stop"
  #           self.stop_bool = true
  #           Satoshi::Cli.info_menu(coin)
  #         else
  #           self.ticker_for_coin(coin)
  #         end
  #       #end
  # end

  def self.get_and_display_price(coin)
    Thread.new do
      while @@stop_bool == false
        puts "-------------------------" if self.coin_array[0] == coin
        new_price = Satoshi::Scraper.scrape_new_price_for_coin(coin.info_link).to_f
        string = "#{coin.name} $#{new_price}"
        if new_price > coin.last_price
          ##green
          string = string.green
        elsif new_price < coin.last_price
          ##gray
          string = string.red
        else
          string = string.black
        end
        puts string
        coin.last_price = new_price
        sleep(5)
      end
    end
  end

  def self.loop_on_new_tread_for_ticker_array
    Thread.new do
      self.coin_array.each{ |coin| self.get_and_display_price(coin)}
    end
  end

  def self.ticker_for_coin_array(coin_called_from)
      puts "Enter stop, search ,or exit to stop ticker".red
      puts "-------------------------"
      puts "-------------------------"
        #Timeout::timeout(20) do
          self.loop_on_new_tread_for_ticker_array
          self.input = gets.chomp.to_s
          case self.input
          when "exit"
            Satoshi::Cli.exit
          when "search"
            Satoshi::Cli.first_prompt_for_coins
          when "stop"
            self.stop_bool = true
            Satoshi::Cli.info_menu(coin_called_from)
          else
            self.ticker_for_coin_array(coin_called_from)
          end
        #end
  end

  def self.stop_bool=(bool)
    @@stop_bool = bool
  end

  def self.stop_bool
    self.stop_bool
  end

  def self.input=(text)
    @@input = text
  end

  def self.input
    @@input
  end

  def self.coin_array=(array)
    @@coin_array = array
  end

  def self.coin_array
    @@coin_array
  end
end
