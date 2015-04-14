class AddAmaraIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :amara_id, :string
  end
end
