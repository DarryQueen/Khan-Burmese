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

  def destroy
    @video = Video.find(params[:video_id])
    @translation = Translation.find(params[:id])

    authorize! :destroy, @translation

    @translation.destroy
    redirect_to video_path @video
  end

  def upload
    @video = Video.find(params[:video_id])
    @translation = Translation.find(params[:translation_id])

    authorize! :upload, @translation

    begin
      @translation.upload_srt(params[:srt])
    rescue ArgumentError => e
      add_flash(:alert, e.message)
    end
    redirect_to video_path @video
  end

  def vote
    @video = Video.find(params[:video_id])
    @translation = Translation.find(params[:translation_id])

    authorize! :review, @translation

    if current_user.voted_as_when_voted_on(@translation).to_s == params[:vote]
      current_user.unvote_for @translation
    else
      @translation.vote_by :voter => current_user, :vote => params[:vote]
    end

    render 'videos/vote'
  end

  def review_mail
    @translation = Translation.find(params[:translation_id])
    @message = h(params[:message]).gsub(/\n/, '<br />').html_safe

    authorize! :review, @translation

    UserMailer.translation_review_email(@translation, current_user, @message).deliver

    add_flash(:notice, 'Your message has been sent!')
    redirect_to :back
  end
end
