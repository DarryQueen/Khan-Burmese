class TranslationsController < ApplicationController
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
