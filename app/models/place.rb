class Place < ActiveRecord::Base
  validates :latitude, :longitude, :comments, presence: true
  has_many :comments

  def self.in_rectangle(point1, point2)
    places = $es.search index: "shizuka", type: "place", body: {
      query:{
        filtered: {
          query: {
            match_all: {}
          },
          filter: {
            geo_bounding_box: {
              location: {
                top_left: point1,
                bottom_right: point2
              }
            }
          }
        }
      }
    }
    places["hits"]["hits"]
  end

  after_save do
    $es.index index: "shizuka", type: "place", id: id, body: {
      location: {
        lat: latitude,
        lon: longitude
      },
      comments: comments.collect { |c|
        { id: c.id, mood: c.mood, things: c.things }
      }
    }
  end

end
