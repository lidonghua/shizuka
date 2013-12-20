class PlacesController < ApplicationController
  def index
  end

  def new
    @place = Place.new
    @place.latitude = params[:latitude]
    @place.longitude = params[:longitude]
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to @place, notice: 'Place was successfully created.'
    else
      render action: 'new'
    end
  end

  private
  def place_params
    params.require(:place).permit(:latitude, :longitude, :mood, :things)
  end
end
