class TranslationsController < ApplicationController
  def create
    @video = Video.find(params[:video_id])
    @translation = Translation.new(:video => @video, :user => current_user)

    unless @translation.save
      @translation.errors.full_messages.each do |error|
        add_flash(:alert, error)
      end
    end

    redirect_to video_path @video
  end

  def upload
    @video = Video.find(params[:video_id])
    @translation = Translation.find(params[:translation_id])

    authorize! :upload, @translation

    begin
      @translation.upload_srt(params[:srt])
    rescue Exception => exception
      add_flash(:alert, exception.message)
    end
    redirect_to video_path @video
  end
end
