class AddPlaceRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :place, index: true
  end
end
