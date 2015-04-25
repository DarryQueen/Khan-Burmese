require 'spec_helper'

describe Translation, :type => :model do
  describe "validations for translations upon creation" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
    end

    it "should have a valid assignment time" do
      translation = Translation.new
      expect(translation.time_assigned).to eq translation.created_at
    end

    it "should raise an error when trying to save a translation without a video" do
      translation = Translation.new
      expect { translation.save! }.to raise_error
    end

    it "should not raise an error when trying to save a translation with a video" do
      translation = Translation.new
      translation.video = @video
      expect { translation.save! }.not_to raise_error
    end

    it "should raise an error when trying to save two translation for same video and user" do
      translation1 = Translation.create(:video => @video, :user => @user)
      translation2 = Translation.new(:video => @video, :user => @user)
      expect { translation2.save! }.to raise_error
    end
  end

  describe "translation points should be calculated correctly" do
    before(:each) do
      @translation = Translation.new
    end

    it "should return 2 points for a priority status video" do
      @translation.stub(:status_symbol).and_return(:complete_with_priority)
      expect(@translation.points).to eq 2
    end

    it "should return 1 point for a normal status video" do
      @translation.stub(:status_symbol).and_return(:complete)
      expect(@translation.points).to eq 1
    end

    it "should return 0 points for an incomplete status video" do
      @translation.stub(:status_symbol).and_return(:incomplete)
      expect(@translation.points).to eq 0
    end
  end

  describe "testing upload_amara" do
    it "should complete a translation after uploading an Amara link" do
      translation = Translation.new(:video => FactoryGirl.create(:video))
      Translation.stub(:verify_link)
      Video.stub(:get_srt_link_from_amara).and_return('http://test_link.com')
      URI.stub(:parse)
      translation.upload_amara('http://test_link')
      expect(translation.complete?).to be true
    end
  end
end
