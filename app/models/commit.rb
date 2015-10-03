class Commit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sha, type: String
  field :event_id, type: String
  field :author, type: String
  field :author_location, type: String
  field :commit_time, type: DateTime
  field :resolving_location, type: Boolean, default: false
  field :resolved, type: Boolean, default: false
end
