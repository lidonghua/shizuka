class Place < ActiveRecord::Base
  validates :latitude, :longitude, presence: true
  has_many :comments
end
