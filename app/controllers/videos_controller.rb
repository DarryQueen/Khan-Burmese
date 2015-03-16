class VideosController < ApplicationController
  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag'

  def index
    @videos = Video.search(params[:search])
  end
end
