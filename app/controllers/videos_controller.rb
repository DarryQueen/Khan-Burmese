class VideosController < ApplicationController
  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag'

  def index
    @videos = Video.search(params[:search]).sort_by {
      |video| video.starred ? 0 : 1
    }
  end

  def show
    @video = Video.find(params[:id])
    @user_translation = Translation.find_by_video_id_and_user_id(@video, current_user)
    @completed_translations = @video.completed_translations
  end

  def toggle_star
    @video = Video.find(params[:video_id])
    authorize! :star, @video

    @video.toggle :starred
    @video.save
  end
end
