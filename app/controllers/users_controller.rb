class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @assigned_videos = @user.untranslated_videos
    @translated_videos = @user.translated_videos
  end
end
