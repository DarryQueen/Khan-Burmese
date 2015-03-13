class Video < ActiveRecord::Base
  attr_accessible :description, :title, :youtube_id

  def youtube_link
    "https://www.youtube.com/watch?v=#{self.youtube_id}"
  end

  def self.search(search)
    if search
      Video.where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
