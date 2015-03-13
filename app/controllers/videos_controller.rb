class VideosController < ApplicationController
  def index
    @videos = Video.search(params[:search])
  end
end
