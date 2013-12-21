class Place < ActiveRecord::Base
  validates :latitude, :longitude, :comments, presence: true
  has_many :comments

  unless $es.indices.exists index: "shizuka"
    $es.indices.create index: "shizuka", body: {
      mappings: {
        place: {
          properties: {
            location: {
              type: "geo_shape",
              precision: "10m"
            }
          }
        }
      }
    }
  end

  after_save do
    $es.index index: "shizuka", type: "place", id: id, body: {
      location: {
        type: "point",
        coordinates: [latitude, longitude]
      },
      comments: comments.collect { |c|
        { id: c.id, mood: c.mood, things: c.things }
      }
    }
  end

end
