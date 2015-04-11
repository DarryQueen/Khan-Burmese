class Translation < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  attr_accessible :user, :video
  acts_as_votable

  validates_presence_of :video
  validates_uniqueness_of :user_id, :scope => :video_id

  after_create :update_time

  @@root_folder_name = 'public/srt/'

  # Maps from integer representation in the database to status symbol:
  @@STATUS_HASH = { 0 => :incomplete, 1 => :complete, 2 => :complete_with_priority }

  # Maps from status symbol to point value:
  @@POINTS_HASH = { :incomplete => 0, :complete => 1, :complete_with_priority => 2 }

  # Maps from status symbol to integer representation for database:
  @@STATUS_TO_INT_HASH = @@STATUS_HASH.invert

  def points
    @@POINTS_HASH[self.status_symbol]
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
    File.exist?(srt_path) and [ :complete_with_priority, :complete ].include? self.status_symbol
  end

  def srt_path
    folder_name = "#{@@root_folder_name}#{self.id}/"
    file_name =  "#{self.id}.srt"
    File.join(folder_name, file_name)
  end

  def upload_srt(srt)
    Translation.verify_file(srt)

    Translation.make_folder(@@root_folder_name)

    folder_name = "#{@@root_folder_name}#{self.id}/"
    Translation.make_folder(folder_name)

    file_name =  "#{self.id}.srt"
    path = File.join(folder_name, file_name)
    File.open(path, 'w+') { |f| f.write(srt.read) }

    update_time
    complete
  end

  private
  def update_time
    self.time_last_updated = Time.now
    self.save
  end

  def self.make_folder(folder_name)
    unless File.exist?(folder_name)
      Dir::mkdir(folder_name)
    end
  end

  def self.verify_file(srt)
    if srt.nil?
      raise ArgumentError, 'Missing file.'
    elsif File.extname(srt.original_filename) != '.srt' 
      raise ArgumentError, 'Invalid file type.'
    end
  end
end
