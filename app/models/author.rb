class Author
  include Mongoid::Document

  field :name, type: String
  field :longitude, type: String
  field :latitude, type: String
  field :location, type: String

  index({ name: 1 }, { unique: true, name: "author_name_index" })
end
