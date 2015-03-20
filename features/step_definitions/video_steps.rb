Given /^the following videos:$/ do |videos|
  videos.hashes.each do |video|
    tags = video.delete('tags').split(', ')
    new_video = Video.new(video)
    new_video.tag_list.add(tags)
    new_video.save!
  end
end
