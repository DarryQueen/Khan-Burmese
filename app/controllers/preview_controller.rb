class PreviewController < ApplicationController
  def show
    authorize! :read, :prototype

    if params[:page]
      render params[:page]
    else
      @pages = Dir.glob("#{Rails.root}/app/views/preview/[^index]*.html.erb").map {
        |path| File.basename(path, '.html.erb')
      }
      render 'index'
    end
  end
end
