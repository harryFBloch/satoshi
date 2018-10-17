class Satoshi::Ticker
  require "timeout"

@@last_price = 0.0
@@stop_bool = false
@@input = " "

  def self.ticker_for_coin(coin)
      puts "press control + c to stop"
      puts "-------------------------"
      puts "-------------------------"
        #Timeout::timeout(20) do
          self.get_and_display_price(coin)
          self.input = gets.chomp.to_s
          case self.input
          when "exit"
            Satoshi::Cli.exit
          when "search"
            self.stop_bool = true
          when "stop"
            self.stop_bool = true
          else
            self.ticker_for_coin(coin)
          end
        #end
  end

  def self.get_and_display_price(coin)
    Thread.new do
      while @@stop_bool == false
        new_price = Satoshi::Scraper.scrape_new_price_for_coin(coin.info_link).to_f
        string = "#{coin.name} $#{new_price}"
        puts "-------------------------".black
        if new_price > @@last_price
          ##green
          string = string.green
        elsif new_price < @@last_price
          ##gray
          string = string.red
        else
          string = string.black
        end
        puts string
        @@last_price = new_price
        sleep(5)
      end
    end
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

  def self.last_price=(price)
    @@last_price == price
  end

  def self.last_price
    @@last_price
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end
