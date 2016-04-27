class VideosController < ApplicationController
  def index
    @videos = Video.search(params[:search], params[:statuses], params[:subjects]).sort_by {
      |video| video.starred ? 0 : 1
    }
    @subjects = Video.all_subjects

    @statuses = Video.statuses.map(&:to_s)

    @default_params = {}
    params[:statuses].each { |status| @default_params[status] = true } if params[:statuses]
  end

  def show
    @video = Video.find(params[:id])
    @user_translation = Translation.find_by_video_id_and_user_id(@video, current_user)
    @completed_translations = @video.completed_translations
    @translators = @video.translators.take(4)
    @reviewers = (@video.reviewers - @video.translators).take(4)
    @similar_videos = @video.similar.take(5)
  end

  def toggle_star
    @video = Video.find(params[:video_id])
    authorize! :star, @video

    @video.toggle :starred
    @video.save
  end

  def import
    authorize! :import, :video

    unless request.post?
      @last_import = Import.order(:time_imported).last
      return
    end

    begin
      Video.verify_csv(params[:file])
    rescue ArgumentError => e
      add_flash(:alert, e.message)
      redirect_to import_videos_path
      return
    end

    import = Import.create
    CSV.foreach(params[:file].path, :headers => true) do |row|
      ImportVideoWorker.perform_async(import.id, row.to_hash)
    end

    add_flash(:notice, 'Your videos are importing, which may take a while. Check back at this page for updates.')
    redirect_to import_videos_path
  end

  def new
    authorize! :import, :video

    @video = Video.new
  end

  def edit
    @video = Video.find(params[:id])
    authorize! :update, @video
  end

  def create
    authorize! :import, :video

    video = Video.new(:youtube_id => params[:video][:youtube_id]).update_from_hash(params[:video])
    if video.save
      redirect_to video_path(video)
    else
      video.errors.full_messages.each { |error| add_flash(:alert, error) }
      redirect_to new_video_path
    end
  end

  def update
    @video = Video.find(params[:id])
    authorize! :update, @video

    @video.update_from_hash(params[:video])
    if @video.save
      redirect_to video_path(@video)
    else
      @video.errors.full_messages.each { |error| add_flash(:alert, error) }
      redirect_to new_video_path
    end
  end

  def destroy
    @video = Video.find(params[:id])
    authorize! :destroy, @video

    @video.destroy
    redirect_to videos_path
  end
end
