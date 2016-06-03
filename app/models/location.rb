class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :longitude, type: String
  field :latitude, type: String

  index name: 1
end
