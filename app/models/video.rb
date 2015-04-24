class Video < ActiveRecord::Base
  require 'YoutubeReader'
  require 'net/http'

  attr_accessible :description, :title, :youtube_id, :starred, :duration
  acts_as_taggable
  acts_as_taggable_on :subject

  has_many :translations
  has_many :translators, :through => :translations, :source => :user

  validates_presence_of :youtube_id
  validates_uniqueness_of :youtube_id

  @@statuses = [ :unassigned, :assigned, :translated, :reviewed ]

  def assigned?
    not self.translations.empty?
  end
  def translated?
    not self.completed_translations.empty?
  end
  def reviewed?
    not self.reviewed_translations.empty?
  end

  def completed_translations
    self.translations.select { |translation| translation.complete? }
  end
  def reviewed_translations
    self.translations.select { |translation| translation.reviewed? }
  end

  def reviewers
    self.completed_translations.map { |translation| translation.reviewers }.flatten
  end

  def youtube_link
    "http://www.youtube.com/embed/#{self.youtube_id}"
  end

  def amara_link
    "http://www.amara.org/en/subtitles/editor/#{self.amara_id}/my/"
  end

  def amara_en_srt
    link = "http://www.amara.org/en/videos/#{self.amara_id}/en/"

    Video.get_srt_link_from_amara(link)
  end

  def status
    if self.assigned?
      return :reviewed if self.reviewed?
      return :translated if self.translated?
      :assigned
    else
      :unassigned
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

    write_attribute(:amara_id, YoutubeReader::amara_id(self.youtube_id))
  end

  def self.recently_translated_videos(time)
    Video.all.select do |video|
      recent = false
      video.translations.each do |translation|
        recent = true if translation.complete? and translation.time_updated > time
      end

      recent
    end
  end

  def self.priority_videos
    Video.where(:starred => true)
  end

  def self.statuses
    @@statuses
  end

  def self.all_subjects
    Video.subject_counts.map { |subject| subject.name }
  end

  def self.search(search, statuses = [], subjects = [])
    videos = scoped

    if search
      videos = videos.where('lower(title) LIKE ?', "%#{search.downcase}%")
    end

    if subjects and not subjects.empty?
      videos = videos.select { |video| not (video.subject_list & subjects).empty? }
    end

    if statuses and not statuses.empty?
      videos = videos.select { |video| statuses.include?(video.status.to_s) }
    end

    videos
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
      video.subject_list.add(row['subject'])

      video.fill_missing_fields
      video.save
    end
  end

  def self.get_srt_link_from_amara(amara_link)
    result = Net::HTTP.get_response(URI.parse(amara_link))
    return nil if [ '404', '403' ].include?(result.code)
    result = Net::HTTP.get_response(URI.parse(result.header['location'])) if [ '302', '301' ].include?(result.code)

    srt_link_match = /<a href="([^"]*)">SRT<\/a>/.match(result.body)
    return nil if srt_link_match.nil?
    "http://www.amara.org/#{srt_link_match[1]}"
  end
end
