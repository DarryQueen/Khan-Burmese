require 'spec_helper'
require 'factories'

describe VideosController do
  include_context 'factories'

  describe "video manipulation" do
    login_admin

    it "can allow an admin to update a video" do
      put 'update', :id => video.id, :video => { 'title' => 'New Title' } 
      expect(video.reload.title).to eq 'New Title'
    end

    it "can allow an admin to delete a video" do
      delete 'destroy', :id => video.id
      deleted_video = Video.find_by_id(video.id)
      expect(deleted_video).to be_nil
    end
  end
end
