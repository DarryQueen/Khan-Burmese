require 'spec_helper'

describe VideosController do
  describe "video manipulation" do
    login_admin

    before(:each) do
      @video = FactoryGirl.create(:video)
    end

    it "can allow an admin to update a video" do
      put 'update', :id => @video.id, :video => { 'title' => 'New Title' } 
      expect(@video.reload.title).to eq 'New Title'
    end

    it "can allow an admin to delete a video" do
      delete 'destroy', :id => @video.id
      video = Video.find_by_id(@video.id)
      expect(video).to be_nil
    end
  end
end
