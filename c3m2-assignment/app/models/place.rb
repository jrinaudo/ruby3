require 'mongo'
require 'pp'
require 'json'

class Place
  include ActiveModel::Model
  
  attr_accessor :id, :formatted_address, :location, :address_components
  
  def initialize args
    @id = args[:_id].to_s
    @formatted_address = args[:formatted_address]
    @location = Point.new(args[:geometry][:geolocation])
    @address_components = []
    args[:address_components].each { |ac| @address_components << AddressComponent.new(ac) } unless args[:address_components].nil?
  end
  
  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    mongo_client[:places]
  end
  
  def self.load_all data_file
    file = File.read(data_file)
    hash = JSON.parse(file)
    collection.insert_many(hash)
  end
  
  def self.find_by_short_name short_name
    collection.find('address_components.short_name' => short_name)
  end
  
  def self.to_places places
    result = []
    places.each { |place| result << Place.new(place) }
    result
  end
  
  def self.find id
    result = collection.find(:_id => BSON::ObjectId.from_string(id)).first
    return Place.new(result) unless result.nil?
  end
  
  def self.all offset=0, limit=0
    places = []
    collection.find().skip(offset).limit(limit).each { |result| places << Place.new(result) }
    places
  end
  
  def destroy
    oid = BSON::ObjectId.from_string(@id)
    self.class.collection.delete_one(:_id => oid)
  end
  
  def self.get_address_components(sort=nil, offset=nil, limit=nil)
    pipeline = [ { :$unwind => "$address_components" },
                 { :$project => { :address_components => 1, :formatted_address => 1, 'geometry.geolocation' => 1 } }
               ]
    pipeline << { :$sort => sort } unless sort.nil?
    pipeline << { :$skip => offset } unless offset.nil?
    pipeline << { :$limit => limit } unless limit.nil?
    collection.find.aggregate(pipeline)
  end
  
  def self.get_country_names
    collection.find.aggregate([ { :$unwind => "$address_components" },
                                { :$unwind => "$types" },
                                { :$project => {'address_components.types' => 1, 'address_components.long_name' => 1 } },
                                { :$match => { 'address_components.types' => "country" } },
                                { :$group => { :_id => "$address_components.long_name" } }
                              ]).to_a.map {|h| h[:_id]}
  end
  
  def self.find_ids_by_country_code country_code
    collection.find.aggregate([ { :$unwind => "$address_components" },
                                { :$unwind => "$types" },
                                { :$project => {'address_components.types' => 1, 'address_components.short_name' => 1 } },
                                { :$match => { 'address_components.types' => "country" } },
                                { :$match => { 'address_components.short_name' => country_code } },
                                { :$group => { :_id => "$_id" } }
                              ]).map {|doc| doc[:_id].to_s}
  end
  
  def self.create_indexes
    collection.indexes.create_one({ 'geometry.geolocation' => Mongo::Index::GEO2DSPHERE })
  end
  
  def self.remove_indexes
    collection.indexes.map {|r| collection.indexes.drop_one(r[:name]) if r[:name].include? '2dsphere' }
  end
  
  def self.near point, max_meters=nil
    if max_meters.nil?
      collection.find( { 'geometry.geolocation' => { :$near => { :$geometry =>
                        { :type => "Point", :coordinates => [ point.longitude , point.latitude ] } } } } )
    else
      collection.find( { 'geometry.geolocation' => { :$near => { :$geometry =>
                        { :type => "Point", :coordinates => [ point.longitude , point.latitude ] },
                          :$maxDistance => max_meters } } } )
    end
  end
  
  def near max_meters=nil
    self.class.to_places(self.class.near(@location, max_meters))
  end
  
  def photos offset=0, limit=0
    Photo.find_photos_for_place(@id).skip(offset).limit(limit).map {|doc| Photo.new(doc) }
  end
  
  def persisted?
    !@id.nil?
  end
end