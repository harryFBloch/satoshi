class Satoshi::Graph
  attr_accessor
  def self.createGraphForCoin(ticker, type , timeframe)
  url = "https://cryptohistory.org/charts/#{type}/#{ticker.downcase}-usd/#{timeframe}/png"
  path = 'lib/satoshi/graph.png'
  File.write path, open(url).read
  self.print_pic(path)
  end

  def self.print_pic(path)
    Catpix::print_image path,
  :limit_x => 0.8,
  :limit_y => 1.0,
  :center_x => true,
  :center_y => true,
  # :bg => "gray",
  # :bg_fill => true,
  :resolution => "high"
  end
end
