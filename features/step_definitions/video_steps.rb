Given /^the following videos:$/ do |videos|
  videos.hashes.each do |video|
    tags = video['subjects'] ? video.delete('subjects').split(', ') : nil
    new_video = Video.new(video)
    new_video.subject_list.add(tags)
    new_video.save!
  end
end

When /^(?:|I )click the star next to "([^"]*)"$/ do |video_title|
  video = Video.find_by_title(video_title)
  star = "toggle-star-#{video.id}"
  page.find_by_id("#{star}").find('a').click()
end

When /^(?:|I )upload the file "([^"]*)" to "([^"]*)"$/ do |filename, inputname|
  attach_file(inputname, File.join(Rails.root, 'features', 'assets', filename))
end

Then /^(?:|I )should see a ?(.*) star next to "([^"]*)"$/ do |star_type, video|
  star_class = ''
  case star_type
  when 'bright'
    star_class = 'fa-star-starred'
  when 'dim'
    star_class = 'fa-star-unstarred'
  else
    star_class = 'fa-star'
  end
  assert(page.body =~ /<tr>.*#{star_class}(?:(?!<\/tr>).)*#{video}.*<\/tr>/m, "No star next to #{video}!")
end

Then /^(?:|I )should not see a star next to "([^"]*)"$/ do |video|
  star_class = 'fa-star'
  assert(!(page.body =~ /<tr>.*#{star_class}(?:(?!<\/tr>).)*#{video}.*<\/tr>/m), "Star next to #{video}!")
end
