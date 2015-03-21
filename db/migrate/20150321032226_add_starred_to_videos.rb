class AddStarredToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :starred, :boolean, :default => false
  end
end
