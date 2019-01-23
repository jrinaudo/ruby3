class Point
  attr_accessor :latitude, :longitude
  
  def initialize args
    args.symbolize_keys!
    if args[:coordinates].nil?
      @latitude = args[:lat]
      @longitude = args[:lng]
    else
      @latitude = args[:coordinates][1]
      @longitude = args[:coordinates][0]
    end
  end
  
  def to_hash
    {:type=>"Point", :coordinates=>[longitude, latitude]}
  end
end