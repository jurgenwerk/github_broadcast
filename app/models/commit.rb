class Commit < ApplicationRecord
  def publish
    if resolved? && author_location
      obj = attributes.slice("event_id", "author_location", "commit_time", "latitude", "longitude", "author")
      ActionCable.server.broadcast("radar_channel", obj)
      puts "published #{obj}"
    end
  end
end
