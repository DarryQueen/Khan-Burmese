class Video < ActiveRecord::Base
  attr_accessible :description, :title, :youtube_id, :starred
  acts_as_taggable

  def youtube_link
    "https://www.youtube.com/watch?v=#{self.youtube_id}"
  end

  def self.search(search)
    if search
      tags = search.split
      tagged_videos = Video.tagged_with(tags, :any => true)
      title_videos = Video.where('title LIKE ?', "%#{search}%")
      (tagged_videos + title_videos).uniq
    else
      scoped
    end
  end
end
