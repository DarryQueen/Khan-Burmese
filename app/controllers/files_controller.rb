class FilesController < ApplicationController
  def download
    rename = params[:rename] || File.basename(params[:filename])
    send_file "#{Rails.root}/#{params[:filename]}", :disposition => 'attachment', :filename => rename
  end
end
