class Place < ActiveRecord::Base
  validates :latitude, :longitude, presence: true
end
