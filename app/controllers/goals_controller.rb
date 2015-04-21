class GoalsController < ApplicationController
  def index
    @number_of_translators_goal = Goal.get_goal(:number_of_translators)
    @number_of_translated_videos_goal = Goal.get_goal(:number_of_translated_videos)
    @number_of_minutes_translated_goal = Goal.get_goal(:number_of_minutes_translated)
  end

  def update
    goal = params[:goal]
    value = params[:value]
    unless (goal.nil? or value.nil?)
      Goal.update_goal(goal, value)
    end
    redirect_to goals_path
  end
end
