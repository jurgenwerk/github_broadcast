require 'clockwork'
require_relative 'config/boot'
require_relative 'config/environment'
require 'sidekiq/api'
require 'open-uri'

module Clockwork

  every(4.seconds, "[#{DateTime.now.to_s}] Fetching commits") do
    CommitFetcher.fetch_and_save
  end

  every(2.seconds, "[#{DateTime.now.to_s}] Resolve locations") do
    CommitFetcher.resolve_locations
  end

  every(3.seconds, "[#{DateTime.now.to_s}] Resolve locations") do
    CommitFetcher.resolve_locations
  end

  every(7.seconds, "[#{DateTime.now.to_s}] Resolve locations") do
    CommitFetcher.resolve_locations
  end

  every(30.seconds, "[#{DateTime.now.to_s}] Fetching commits") do
    CommitFetcher.delete_old
  end

  every(1.minute, "[#{DateTime.now.to_s}] Clear queue") do
    Sidekiq::Queue.new("resolving").clear
  end

  every(1.day, "[#{DateTime.now.to_s}] Clear stale commits") do
    CommitFetcher.cleanup
    Sidekiq::Queue.new("resolving").clear
  end

  every(15.minutes, "[#{DateTime.now.to_s}] scrape boros") do
    page = Nokogiri::HTML(open("https://www.sammlung-boros.de/visit/book-tour.html?L=1"))
    available_places = page.css('.accordion_item:first-of-type .blockrow.en .block_empty')
    dates = available_places.map do |place|
      place.parent.css('.date').text
    end.uniq

    if dates.any?
      notifier = Slack::Notifier.new("https://hooks.slack.com/services/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", channel: "#cocojambo")
      notifier.ping("Boros available september: #{dates.join(', ')}")
    end
  end
end
