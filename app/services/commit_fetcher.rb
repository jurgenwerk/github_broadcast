class CommitFetcher

  def self.fetch_and_save
    events = Github.new(basic_auth: TokenMaster.get_token).activity.events.public(per_page: 40).map{ |e| [e.id, e.created_at, e.actor.login] }
    events.each do |event|
      event_id = event[0]
      Commit.create(event_id: event_id, commit_time: event[1], author: event[2])
    end
  end

  def self.delete_old
    # Leave a few (with offset) so available work doesn't fall to 0
    Commit.where(resolving_location: false, resolved: false).offset(20).delete_all
    Commit.where(resolved: true, author_location: nil).delete_all
  end

  def self.resolve_locations
    commits = Commit.where(resolving_location: false, resolved: false).order("created_at desc").take(6)
    commits.each do |commit|
      commit.update(resolving_location: true)
      ResolveLocationJob.perform_later(commit.event_id)
    end
  end

  def self.cleanup
    Commit.delete_all
  end
end
