class ApplicationController < ActionController::Base
  def store_location
    longitude = params[:longitude]
    latitude = params[:latitude]
    name = params[:name].downcase.titleize

    if longitude.present? && latitude.present? && name.present?
      Location.where(name: name).first || Location.create(name: name, longitude: longitude, latitude: latitude)
    end

    render json: {}, status: :ok
  end
end
