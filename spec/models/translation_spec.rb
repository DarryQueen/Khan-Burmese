require 'spec_helper'

describe Translation, :type => :model do
  describe "validations for translations upon creation" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
    end

    it "should raise an error when trying to save a translation without a video" do
      translation = Translation.new
      expect {translation.save!}.to raise_error
    end

    it "should not raise an error when trying to save a translation with a video" do
      translation = Translation.new
      translation.video = @video
      expect {translation.save!}.not_to raise_error
    end

  end
end
