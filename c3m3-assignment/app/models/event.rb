class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String
  
  embedded_in :parent, polymorphic: true, touch: true, class_name: 'Race'

  validates_presence_of :order, :name, order: [:"event.o".asc]
  
  def meters
    case self.units
    when 'meters' then return self.distance
    when 'kilometers' then return self.distance * 1000
    when 'yards' then return self.distance * 0.9144
    when 'miles' then return self.distance * 1609.344
    end
  end
  
  def miles
    case self.units
    when 'miles' then return self.distance
    when 'kilometers' then return self.distance * 0.621371
    when 'yards' then return self.distance * 0.000568182
    when 'meters' then return self.distance * 0.000621371
    end
  end
end
