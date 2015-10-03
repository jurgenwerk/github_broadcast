class CommitFetcher

  def self.fetch_and_save
    delete_old
    events = Github.new.activity.events.public(per_page: 30).map{ |e| [e.id, e.created_at, e.actor.login] }
    commits = []
    events.each do |event|
      commits.push(Commit.create(event_id: event[0], commit_time: event[1], author: event[2]))
    end
  end

  def self.delete_old
    Commit.where(resolving_location: false, resolved: false).destroy_all
    Commit.where(resolved: true, author_location: nil).destroy_all
  end

  def self.resolve_locations
    commits = Commit.where(resolving_location: false, resolved: false).take(7)
    commits.each do |commit|
      commit.update(resolving_location: true)
      # even out job triggers
      rand = rand()
      if rand > 0.33
        if rand > 0.66
          ResolveLocationJob.set(wait: 1.second).perform_later(commit.event_id)
        else
          ResolveLocationJob.set(wait: 2.seconds).perform_later(commit.event_id)
        end
      else
        ResolveLocationJob.perform_later(commit.event_id)
      end
    end
  end
end
