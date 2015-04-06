class Video < ActiveRecord::Base
  attr_accessible :description, :title, :youtube_id, :starred
  acts_as_taggable

  has_many :translations
  has_many :translators, :through => :translations, :source => :user

  validates_uniqueness_of :youtube_id

  def translated?
    not self.completed_translations.empty?
  end

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

  def self.import(file)
    if File.extname(file.original_filename) != ".csv"
      raise ArgumentError, "Only CSV files are allowed."
    end

    CSV.foreach(file.path, headers: true) do |row|
      if row['youtube_id'].nil?
        raise ArgumentError, "Need <code>youtube_id</code> column in CSV file.".html_safe
      end

      attributes = row.to_hash.slice('description', 'title', 'youtube_id')
      video = Video.create(attributes)
    end
  end
end
