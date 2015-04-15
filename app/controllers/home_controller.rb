class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if user_signed_in?
      flash.keep
      redirect_to dashboard_path
    end
  end

  def dashboard
    @assigned_videos = current_user.assigned_videos
    @translated_videos = current_user.translated_videos
    @recently_translated_videos = Video.recently_translated_videos(1.week.ago).take(5)
    @priority_videos = Video.priority_videos.take(5)
    @reviewed_videos = current_user.reviewed_videos

    @percent_translators, @percent_translators_status = Goal.percent_translators
    @percent_translated_videos, @percent_translated_videos_status = Goal.percent_translated_videos
    @percent_minutes_translated, @percent_minutes_translated_status = Goal.percent_minutes_translated

  end
end
