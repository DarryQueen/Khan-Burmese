class Goal < ActiveRecord::Base
  @@DEFAULT_GOALS = { :number_of_translators => 50, :number_of_translated_videos => 100,
  	                :number_of_minutes_translated => 1000 }

  attr_accessible :descriptor, :value
  validates_presence_of :descriptor, :value
  

  def self.percent_translators
  	percent = (User.number_of_translators.to_f / self.get_goal(:number_of_translators) * 100)
    return percent.to_s, self.progress_status(percent)
  end

  def self.percent_translated_videos
    percent = (Video.number_of_translated_videos.to_f / self.get_goal(:number_of_translated_videos) * 100)
    return percent.to_s, self.progress_status(percent)
  end

  def self.percent_minutes_translated
    percent = (Video.number_of_minutes_translated.to_f / self.get_goal(:number_of_minutes_translated) * 100)
    return percent.to_s, self.progress_status(percent)
  end

  def self.get_goal(descriptor)
  	preset_goal = Goal.find_by_descriptor(descriptor.to_s)
  	if preset_goal.nil?
  	  preset_goal = Goal.create(:descriptor => descriptor.to_s, :value => @@DEFAULT_GOALS[descriptor])
    end
    preset_goal.value
  end

  def self.update_goal(goal_name, value)
  	goal = Goal.find_by_descriptor(goal_name)
  	if goal.nil?
  	  raise Exception("No such goal exists.")
  	end
  	goal.value = value
  	goal.save
  end

  private
  def self.progress_status(percent)
  	if percent < 30
  		return "warning"
  	elsif percent < 100
  		return "active"
  	else
  		return "success"
  	end
  end

end
