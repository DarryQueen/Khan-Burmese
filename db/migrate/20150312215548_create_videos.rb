class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
