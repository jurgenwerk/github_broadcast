require "i18n"
require "benchmark"

class ResolveLocationJob < ActiveJob::Base
  queue_as :resolving

  def perform(event_id)
    time = Benchmark.measure do
      commit = Commit.where(event_id: event_id).first
      return unless commit
      commit.update(resolving_location: true)
      location = Github.new(basic_auth: TokenMaster.get_token).users.get(user: commit.author).location.try!(:strip).presence

      if location
        location = I18n.transliterate(location).downcase.titleize

        # did we cache the coordinates sometime before?
        cached_location = Location.where(name: location).first
        latitude = cached_location.try!(:latitude)
        longitude = cached_location.try!(:longitude)

        commit.update(resolving_location: false, resolved: true, author_location: location, latitude: latitude, longitude: longitude)
      end
    end
    # puts "Resolving location took #{time}"
  end
end
