class Comment < ActiveRecord::Base
  validates :mood, presence: true
  belongs_to :place
end
