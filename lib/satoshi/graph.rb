class Satoshi::Graph
  attr_accessor
  def self.createGraphForCoin(ticker, type , timeframe)
  ticker = "iota" if ticker == "MIOTA"
  url = "https://cryptohistory.org/charts/#{type}/#{ticker.downcase}-usd/#{timeframe}/png"
  path = "#{__dir__}/graph.png"

  begin
  File.write path, open(url).read
  rescue OpenURI::HTTPError
      puts "ERROR WITH TICKER FOR THAT COIN"
    else
      self.print_pic(path)
    end
  end

  def self.print_pic(path)
    Catpix::print_image path,
  :limit_x => 0.8,
  :limit_y => 1.2,
  :center_x => true,
  :center_y => true,
  # :bg => "gray",
  # :bg_fill => true,
  :resolution => "high"
  end
end
