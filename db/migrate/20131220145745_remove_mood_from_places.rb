class RemoveMoodFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :mood, :string
    remove_column :places, :things, :text
  end
end
