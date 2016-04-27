class ImportVideoWorker
  include Sidekiq::Worker

  def perform(import_id, attributes)
    import = Import.find(import_id)

    if attributes['youtube_id'].blank?
      import.success = false
      import.messages += 'New videos need the youtube_id field.'
      import.save

      return
    end

    # Prematurely skip already-created videos:
    if Video.find_by_youtube_id(attributes['youtube_id'])
      return
    end

    video = Video.new(:youtube_id => attributes['youtube_id']).update_from_hash(attributes)
    if video.save
      import.videos << video
    else
      import.messages += video.errors.full_messages
    end

    import.save
  end
end
