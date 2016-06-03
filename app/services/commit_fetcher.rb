class CommitFetcher

  def self.fetch_and_save
    delete_old
    events = Github.new(basic_auth: TokenMaster.get_token).activity.events.public(per_page: 40).map{ |e| [e.id, e.created_at, e.actor.login] }
    events.each do |event|
      Commit.create(event_id: event[0], commit_time: event[1], author: event[2])
    end
  end

  def self.delete_old
    Commit.where(resolving_location: false, resolved: false).destroy_all
    Commit.where(resolved: true, author_location: nil).destroy_all
  end

  def self.resolve_locations
    commits = Commit.where(resolving_location: false, resolved: false).take(4)
    commits.each do |commit|
      commit.update(resolving_location: true)
      ResolveLocationJob.perform_later(commit.event_id)
    end
  end
end
