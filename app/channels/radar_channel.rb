# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RadarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "radar_channel"
  end

  def save_location(location_params)
    name = location_params["name"]
    latitude = location_params["latitude"]
    longitude = location_params["longitude"]
    return if name && Location.where(name: name).first
    Location.create(name: name, longitude: longitude, latitude: latitude)
  end
end
