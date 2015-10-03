require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GithubBroadcast
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq

    Mongoid.logger.level = Logger::ERROR
    Mongo::Logger.logger.level = Logger::ERROR
  end
end
