class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :mood
      t.text :things

      t.timestamps
    end
  end
end
