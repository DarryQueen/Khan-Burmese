class Video < ActiveRecord::Base
  attr_accessible :description, :title, :youtube_id

  def youtube_link
    "https://www.youtube.com/watch?v=#{self.youtube_id}"
  end
end
