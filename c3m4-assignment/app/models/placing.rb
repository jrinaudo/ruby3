class Placing
  attr_accessor :name, :place

  def initialize name, place
    @name = name
    @place = place
  end
  
  def mongoize
    {:name => @name, :place => @place}
  end
  
  def self.mongoize object
    case object
    when nil then return nil
    when Hash then return object
    when Placing then return object.mongoize
    end
  end
  
  def self.demongoize object
    case object
    when nil then return nil
    when Hash then return Placing.new(object[:name], object[:place])
    when Placing then return object
    end
  end
  
  def self.evolve object
    mongoize(object)
  end
end