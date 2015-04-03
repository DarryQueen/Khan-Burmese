class Translation < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  attr_accessible :user, :video

  validates_presence_of :video

  def upload_srt(srt)
    Translation.verify_file(srt)

    root_folder_name = 'public/srt/'
    Translation.make_folder(root_folder_name)

    folder_name = "#{root_folder_name}#{self.id}/"
    Translation.make_folder(folder_name)

    file_name =  "#{self.id}.srt"
    path = File.join(folder_name, file_name)
    File.open(path, 'w+') { |f| f.write(srt.read) }
  end

  private
  def self.make_folder(folder_name)
    unless File.exist?(folder_name)
      Dir::mkdir(folder_name)
    end
  end

  def self.verify_file(srt)
    if srt.nil?
      raise Exception.new('Missing file.')
    elsif File.extname(srt.original_filename) != '.srt' 
      raise Exception.new('Invalid file type.')
    end
  end
end
