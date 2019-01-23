class Point
  attr_accessor :longitude, :latitude
  
  def initialize longitude, latitude
    @longitude = longitude
    @latitude = latitude
  end
  
  def mongoize
    {:type=>"Point", :coordinates=>[@longitude, @latitude]}
  end
  
  def self.mongoize object
    case object
    when nil then return nil
    when Hash then return object
    when Point then return object.mongoize
    end
  end
  
  def self.demongoize object
    case object
    when nil then return nil
    when Hash then return Point.new(object[:coordinates][0], object[:coordinates][1])
    when Point then return object
    end
  end
  
  def self.evolve object
    mongoize(object)
  end
end