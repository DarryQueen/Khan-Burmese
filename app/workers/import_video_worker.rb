class ImportVideoWorker
  include Sidekiq::Worker

  def perform(attributes)
    if attributes['youtube_id'].blank?
      # Add an error message here.

      return
    end

    # Prematurely skip already-created videos:
    if Video.find_by_youtube_id(attributes['youtube_id'])
      return
    end

    video = Video.new(:youtube_id => attributes['youtube_id']).update_from_hash(attributes)

    video.errors.full_messages
  end
end
