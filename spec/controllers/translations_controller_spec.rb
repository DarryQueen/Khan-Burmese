require 'spec_helper'

describe TranslationsController do
  describe "create translation" do
    login_user

    before(:each) do
      @user = User.find_by_email('normal@user.com')
      @video = FactoryGirl.create(:video)
    end

    it "should create a single translation" do
      expect {
        put 'create', :user_id => @user.id, :video_id => @video.id
      }.to change(Translation, :count).by(1)
    end

    it "error upon creating two translations for the same user and video" do
      put 'create', :user_id => @user.id, :video_id => @video.id

      expect {
        put 'create', :user_id => @user.id, :video_id => @video.id
      }.not_to change(Translation, :count)
    end
  end
end
