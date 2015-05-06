class Video < ActiveRecord::Base
  require 'YoutubeReader'
  require 'net/http'

  attr_accessible :description, :title, :youtube_id, :starred, :duration
  acts_as_taggable
  acts_as_taggable_on :subject

  has_many :translations, :dependent => :destroy
  has_many :translators, :through => :translations, :source => :user

  validates_presence_of :youtube_id
  validates_uniqueness_of :youtube_id

  before_create :fill_missing_fields

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

  def update_from_hash(video_hash)
    keys = [ 'description', 'title' ]
    self.update_attributes(video_hash.slice(*keys))

    self.subject_list = video_hash['subject']

    if self.save and video_hash['translated?'] and video_hash['translated?'].downcase != 'false'
      translation = Translation.new(:video => self)

      begin
        link = "http://www.amara.org/en/videos/#{self.amara_id}/my/"
        translation.upload_amara(link)
      rescue ArgumentError => e
        self.errors.add(:base, e.message)
      end
    end

    self
  end

  def fill_missing_fields
    youtube_values = {}

    begin
      youtube_values = YoutubeReader::parse_video(self.youtube_id)
    rescue ArgumentError => e
      self.errors.add(:base, "#{e.message} for \"#{self.title}\" video.")
      return false
    end

    unless youtube_values.empty?
      fields = [ 'description', 'title', 'duration' ]
      fields.each do |field|
        write_attribute(field, youtube_values[field]) if self[field].blank?
      end
    end

    write_attribute(:amara_id, YoutubeReader::amara_id(self.youtube_id))
  end

  def similar
    Video.search(nil, ['unassigned', 'assigned'], self.subject_list) - [self]
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
    self.verify_csv(file)

    errors = []
    CSV.foreach(file.path, headers: true) do |row|
      if row['youtube_id'].blank?
        errors << 'New videos need <code>youtube_id</code>.'.html_safe
        next
      end

      # Prematurely skip already-created videos:
      if Video.find_by_youtube_id(row['youtube_id'])
        next
      end

      video = Video.new(:youtube_id => row['youtube_id']).update_from_hash(row.to_hash)

      errors += video.errors.full_messages
    end
    errors
  end
  def self.verify_csv(file)
    unless file
      raise ArgumentError, 'Missing file.'
    end

    if File.extname(file.original_filename) != ".csv"
      raise ArgumentError, 'Invalid file type.'
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
