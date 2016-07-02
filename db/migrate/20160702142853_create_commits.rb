class CreateCommits < ActiveRecord::Migration[5.0]
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :event_id, index: true
      t.string :author
      t.string :author_location
      t.datetime :commit_time
      t.boolean :resolving_location, default: false
      t.boolean :resolved, default: false
      t.string :longitude
      t.string :latitude

      t.timestamps
    end
  end
end
