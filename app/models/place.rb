class Place < ActiveRecord::Base
  validates :latitude, :longitude, :comments, presence: true
  has_many :comments

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
