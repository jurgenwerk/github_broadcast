# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
ActionCable.server.config.allowed_request_origins = ["http://localhost:4200"]
run Rails.application
