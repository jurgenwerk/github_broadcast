require 'clockwork'
require_relative 'config/boot'
require_relative 'config/environment'
require 'sidekiq/api'

module Clockwork

  every(5.seconds, "[#{DateTime.now.to_s}] Fetching commits") do
    CommitFetcher.fetch_and_save
  end

  every(3.seconds, "[#{DateTime.now.to_s}] Resolve locations") do
    CommitFetcher.resolve_locations
  end

  every(2.seconds, "[#{DateTime.now.to_s}] Resolve locations") do
    CommitFetcher.resolve_locations
  end

  every(30.seconds, "[#{DateTime.now.to_s}] Fetching commits") do
    CommitFetcher.delete_old
  end

  every(1.minute, "[#{DateTime.now.to_s}] Clear queue") do
    Sidekiq::Queue.new("resolving").clear
  end
end
