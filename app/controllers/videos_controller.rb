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

  def import
    authorize! :import, :video

    if request.post?
      begin
        Video.import(params[:file])
        add_flash(:notice, 'Video(s) imported!')
        redirect_to videos_path
      rescue ArgumentError => e
        add_flash(:alert, "#{e.message}")
        redirect_to import_videos_path
      end
    end
  end
end
