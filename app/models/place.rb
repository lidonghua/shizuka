class Place < ActiveRecord::Base
  validates :latitude, :longitude, :mood, presence: true
end
