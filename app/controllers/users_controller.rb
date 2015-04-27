class UsersController < ApplicationController
  @@LEADERBOARD_LIMIT = 10

  def show
    @user = User.find(params[:id])
    @assigned_videos = @user.assigned_videos
    @translated_videos = @user.translated_videos
    @reviewed_videos = @user.reviewed_videos
  end

  def update
    @user = User.find params[:id]

    authorize! :update, @user

    if @user.update_attributes!(params[:user])
      respond_to do |format|
        format.html { redirect_to @user }
        format.json { render :json => @user }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render :nothing => true }
      end
    end
  end

  def leaderboard
    @assigned_videos = current_user.assigned_videos
    @translated_videos = current_user.translated_videos
    @reviewed_videos = current_user.reviewed_videos

    @standings = params[:standings] || 'all_time'
    if @standings == 'year'
      @after = 1.year.ago
    elsif @standings == 'month'
      @after = 1.month.ago
    else
      @after = Time.new(0)
    end
    @default_params = { @standings => true }

    @leaders = User.leaders(@after).take(@@LEADERBOARD_LIMIT)
  end
end
