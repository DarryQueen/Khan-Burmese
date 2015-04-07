class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @assigned_videos = @user.untranslated_videos
    @translated_videos = @user.translated_videos
  end

  def update
    @user = User.find params[:id]

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
end
