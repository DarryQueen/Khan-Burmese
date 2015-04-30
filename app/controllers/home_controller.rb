class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if user_signed_in?
      flash.keep
      redirect_to dashboard_path
    end
  end

  def admin_dashboard
    authorize! :access, :admin_dashboard

    @statistics = {
      :members => User.count,
      :untranslated_videos => Video.search(nil, [ 'unassigned', 'assigned' ]).length,
      :translated_videos => Video.search(nil, [ 'translated', 'reviewed' ]).size,
      :reviewed_videos => Video.search(nil, [ 'reviewed' ]).size,
    }
  end

  def dashboard
    @assigned_videos = current_user.assigned_videos
    @translated_videos = current_user.translated_videos
    @recently_translated_videos = Video.recently_translated_videos(1.week.ago).take(5)
    @priority_videos = Video.priority_videos.take(5)
    @reviewed_videos = current_user.reviewed_videos
    @after = 1.month.ago
    @leaders = User.leaders(@after).take(3)
  end
end
