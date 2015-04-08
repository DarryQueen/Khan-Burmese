class Translation < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  attr_accessible :user, :video

  validates_presence_of :video
  validates_uniqueness_of :user_id, :scope => :video_id

  after_create :update_time

  @@root_folder_name = 'public/srt/'

  def time_assigned
    self.created_at
  end

  def time_updated
    self.time_last_updated
  end

  def complete?
    File.exist?(srt_path)
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
