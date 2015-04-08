class Video < ActiveRecord::Base
  require 'YoutubeReader'

  attr_accessible :description, :title, :youtube_id, :starred, :duration
  acts_as_taggable

  has_many :translations
  has_many :translators, :through => :translations, :source => :user

  validates_presence_of :youtube_id
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
    unless file
      raise ArgumentError, 'Missing file.'
    end

    if File.extname(file.original_filename) != ".csv"
      raise ArgumentError, 'Invalid file type.'
    end

    CSV.foreach(file.path, headers: true) do |row|
      if row['youtube_id'].nil?
        raise ArgumentError, "Need <code>youtube_id</code> column in CSV file.".html_safe
      end

      keys = [ 'description', 'title', 'youtube_id', 'duration' ]
      attributes = row.to_hash.slice(*keys)

      video = Video.new(attributes)
      video.fill_missing_fields
      video.save
    end
  end

  def fill_missing_fields
    youtube_values = {}

    begin
      youtube_values = YoutubeReader::parse_video(self.youtube_id)
    rescue
    end

    unless youtube_values.empty?
      fields = [ 'description', 'title', 'duration' ]
      fields.each do |field|
        write_attribute(field, youtube_values[field]) unless self[field]
      end
    end
  end
end
