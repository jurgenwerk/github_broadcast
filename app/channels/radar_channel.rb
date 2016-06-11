# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RadarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "radar_channel"
  end

  def save_location(location_params)
    location = location_params["location_name"]
    latitude = location_params["latitude"]
    longitude = location_params["longitude"]
    author = location_params["author"]

    if location_name && !Location.where(name: location_name).first
      Location.create(name: location, longitude: longitude, latitude: latitude)
    end

    if author && !Author.where(name: author).first
      Author.create(name: author, location: location, latitude: latitude, longitude: longitude)
    end
  end
end
