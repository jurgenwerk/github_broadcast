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
  field :longitude, type: String
  field :latitude, type: String

  before_update :publish

  def publish
    if resolved && author_location && author_location_changed?
      firehose ||= Firehose::Client::Producer::Http.new(ENV['FIREHOSE_URL'])
      obj = attributes.slice(:event_id, :author_location, :commit_time, :latitude, :longitude)
      firehose.publish(obj.to_json).to("/github_broadcast")
    end
  end
end
