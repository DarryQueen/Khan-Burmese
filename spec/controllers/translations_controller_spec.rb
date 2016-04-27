require 'spec_helper'
require 'factories'

describe TranslationsController do
  include_context 'factories'

  describe "create translation" do
    login_user

    it "should create a single translation" do
      expect {
        put 'create', :user_id => user.id, :video_id => video.id
      }.to change(Translation, :count).by(1)
    end

    it "error upon creating two translations for the same user and video" do
      put 'create', :user_id => user.id, :video_id => video.id

      expect {
        put 'create', :user_id => user.id, :video_id => video.id
      }.not_to change(Translation, :count)
    end
  end

  describe "destroy translation" do
    login_user

    before(:each) do
      translation

      # Ignore authorization:
      controller.stub(:authorize!)
    end

    it "should delete a single translation" do
      expect {
        delete 'destroy', :video_id => video.id, :id => translation.id
      }.to change(Translation, :count).by(-1)
    end
  end

  describe "upload, vote, submit_amara, review_email" do
    login_user

    let(:translator) { admin }

    before(:each) do
      # Ignore authorization and rendering:
      controller.stub(:authorize!)
      controller.stub(:render).and_return(nil)
      controller.stub(:redirect_to).and_return(nil)
    end

    it "should raise an error if the uploading to amara fails" do
      post 'submit_amara', :video_id => video.id, :translation_id => translation.id, :amara_link => 'bad_link'
      expect(controller.flash[:alert]).to include 'Invalid link format.'
    end

    it "should correctly register a vote" do
      translation = Translation.create(:user => translator, :video => video)
      expect {
        put 'vote', :video_id => video.id, :translation_id => translation.id, :vote => true
      }.to change(translation, :net_votes).by(1)
    end

    it "should send an email when reviewing" do
      post 'review_mail', :translation_id => translation.id, :video_id => video.id, :message => 'Test'
      expect(controller.flash[:notice]).to include 'Your message has been sent!'
    end
  end
end
