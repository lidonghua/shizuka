class PlacesController < ApplicationController
  def index
  end

  def new
    @place = Place.new
    @place.latitude = params[:latitude]
    @place.longitude = params[:longitude]
  end
end
