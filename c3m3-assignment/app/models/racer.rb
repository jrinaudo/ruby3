class Racer
  include Mongoid::Document
  delegate :first_name, :first_name=, to: :info
  delegate :last_name, :last_name=, to: :info
  delegate :gender, :gender=, to: :info
  delegate :birth_year, :birth_year=, to: :info
  delegate :city, :city=, to: :info
  delegate :state, :state=, to: :info
      
  embeds_one :info, as: :parent, class_name: 'RacerInfo', autobuild: true
  has_many :races, class_name: 'Entrant', foreign_key: 'racer.racer_id', dependent: :nullify, order: :"race.date".desc
  
  before_create do |racer|
    racer.info.id = racer.id
  end
end
