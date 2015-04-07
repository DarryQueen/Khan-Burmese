class Video < ActiveRecord::Base
  attr_accessible :description, :title, :youtube_id, :starred
  acts_as_taggable

  has_many :translations
  has_many :translators, :through => :translations, :source => :user

  def completed_translations
    self.translations.select { |translation| translation.complete? }
  end

  def youtube_link
    "http://www.youtube.com/embed/#{self.youtube_id}"
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
