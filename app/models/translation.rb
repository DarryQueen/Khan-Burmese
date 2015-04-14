class Translation < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  attr_accessible :user, :video, :srt
  acts_as_votable

  has_attached_file :srt,
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :dropbox_visibility => 'private',
    :path => "#{Rails.env}/srt/:id/translation.srt"

  validates_presence_of :video
  validates_uniqueness_of :user_id, :scope => :video_id

  after_create :update_time

  # Maps from integer representation in the database to status symbol:
  @@STATUS_HASH = { 0 => :incomplete, 1 => :complete, 2 => :complete_with_priority }

  # Maps from status symbol to point value:
  @@POINTS_HASH = { :incomplete => 0, :complete => 1, :complete_with_priority => 2 }

  # Maps from status symbol to integer representation for database:
  @@STATUS_TO_INT_HASH = @@STATUS_HASH.invert

  def points
    @@POINTS_HASH[self.status_symbol]
  end

  def reviewers
    self.votes_for.voters
  end

  def net_votes
    self.get_upvotes.size - self.get_downvotes.size
  end

  def status_symbol
    return @@STATUS_HASH[self.status]
  end

  def time_assigned
    self.created_at
  end

  def time_updated
    self.time_last_updated
  end

  def complete
    unless self.complete?
      new_status = self.video.starred ? @@STATUS_TO_INT_HASH[:complete_with_priority] : @@STATUS_TO_INT_HASH[:complete]
      self.status = new_status
      self.save
    end
  end

  def complete?
    [ :complete_with_priority, :complete ].include? self.status_symbol
  end

  def upload_srt(srt_file)
    Translation.verify_file(srt_file)

    self.srt = srt_file
    self.save

    update_time
    complete
  end

  def upload_amara(amara_link)
    amara_link = amara_link.gsub('https', 'http')
    Translation.verify_link(amara_link)

    srt_link = Video.get_srt_link_from_amara(amara_link)
    raise ArgumentError, 'No SRT published.' unless srt_link

    self.srt = URI.parse(srt_link)
    self.save

    update_time
    complete
  end

  private
  def update_time
    self.time_last_updated = Time.now
    self.save
  end

  def self.verify_file(srt)
    if srt.nil?
      raise ArgumentError, 'Missing file.'
    elsif File.extname(srt.original_filename) != '.srt' 
      raise ArgumentError, 'Invalid file type.'
    end
  end

  def self.verify_link(amara_link)
    unless amara_link =~ /^http:\/\/www.amara.org\/en\/videos\/([\w\d]+)\/my\/(\d+)\/?$/
      raise ArgumentError, 'Invalid link format.'
    end
  end
end
