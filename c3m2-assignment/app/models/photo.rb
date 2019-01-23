require 'exifr/jpeg'

class Photo
  attr_accessor :id, :location, :place
  attr_writer :contents
  
  def initialize args={}
    args.symbolize_keys!
    @id = args[:_id].to_s unless args[:_id].nil?
    @location = Point.new(args[:metadata][:location]) unless args[:metadata].nil?
    @place = args[:metadata][:place] unless args[:metadata].nil?
  end
  
  def self.mongo_client
    Mongoid::Clients.default
  end
  
  def persisted?
    !@id.nil?
  end
  
  def save
    if persisted?
      self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).update_one(:metadata => {:location => @location.to_hash, :place => @place})
    else
      gps = EXIFR::JPEG.new(@contents).gps
      @location = Point.new(:lng => gps.longitude, :lat => gps.latitude)
      description = {}
      description[:filename] = File.basename(@contents)
      description[:content_type] = 'image/jpeg'
      description[:metadata] = {:location => @location.to_hash, :place => @place}
      @contents.rewind
      grid_file = Mongo::Grid::File.new(@contents.read, description)
      @id = self.class.mongo_client.database.fs.insert_one(grid_file)
    end
  end
  
  def self.all offset=0, limit=0
    mongo_client.database.fs.find().skip(offset).limit(limit).map {|doc| Photo.new(doc) }
  end
  
  def self.find id
    result = mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(id)).first
    unless result.nil?
      @id = result[:_id].to_s
      @location = Point.new(result[:metadata][:location])
      @place = result[:metadata][:place]
      Photo.new(result)
    end
  end
  
  def contents
    file = ""
    self.class.mongo_client.database.fs.find_one(:_id => BSON::ObjectId.from_string(@id)).chunks.reduce([]) { |x,chunk| file << chunk.data.data }
    file
  end
  
  def destroy
    file = self.class.mongo_client.database.fs.find_one(:_id => BSON::ObjectId.from_string(@id))
    self.class.mongo_client.database.fs.delete_one(file)
  end
  
  def find_nearest_place_id max_meters
    Place.near(@location, max_meters).limit(1).projection(:_id => 1).first['_id']
  end
  
  def place
    Place.find(@place.to_s) unless @place.nil?
  end
  
  def place= place
    case
      when place.is_a?(String)
        @place = BSON::ObjectId.from_string(place)
      when place.is_a?(Place)
        @place = BSON::ObjectId.from_string(place.id)
      else
        @place = place
    end
  end
  
  def self.find_photos_for_place place_id
    mongo_client.database.fs.find('metadata.place' => BSON::ObjectId.from_string(place_id.to_s))
  end
end