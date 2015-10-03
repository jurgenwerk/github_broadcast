class ResolveLocationJob < ActiveJob::Base
  queue_as :resolving

  def perform(event_id)
    commit = Commit.where(event_id: event_id).first
    return unless commit
    commit.update(resolving_location: true)
    location = Github.new.users.get(user: commit.author).location.try!(:strip).presence
    commit.update(resolving_location: false, resolved: true, author_location: location)
  end
end
