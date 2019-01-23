class Address
  attr_accessor :city, :state, :location

  def initialize city=nil, state=nil, location=nil
    @city = city
    @state = state
    @location = Point.demongoize(location)
  end
  
  def mongoize
    {:city => @city, :state => @state, :loc => @location.mongoize}
  end
  
  def self.mongoize object
    case object
    when nil then return nil
    when Hash then return object
    when Address then return object.mongoize
    end
  end
  
  def self.demongoize object
    case object
    when nil then return nil
    when Hash then return Address.new(object[:city], object[:state], object[:loc])
    when Address then return object
    end
  end
  
  def self.evolve object
    mongoize(object)
  end
end