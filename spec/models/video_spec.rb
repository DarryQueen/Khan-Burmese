require 'spec_helper'

describe Video, :type => :model do
  describe "accessing translations and related users" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
    end

    it "should be able to access translations through video.translations" do
      expect { @video.translations }.not_to raise_error
      translations = @video.translations
      expect(translations).to include @translation
    end

    it "should be able to access users through video.translators" do
      expect { @video.translators }.not_to raise_error
      translators = @video.translators
      expect(translators).to include @user
    end
  end

  describe "methods related to translations" do
    before(:each) do
      @video = FactoryGirl.create(:video)
      @user = FactoryGirl.create(:user)
      @translation = Translation.create(:user => @user, :video => @video)

      @translation.vote_by :voter => @user, :vote => true
      @translation.complete
    end

    it "should claim it is unassigned if there is no user/video associated with it" do
      expect(Video.new.assigned?).to eq false
    end

    it "should claim it is assigned if there is a user/video associated with it" do
      expect(@video.assigned?).to eq true
    end

    it "should include translations that are associated with it in reviewed_translations" do
      expect(@video.reviewed_translations).to include @translation
    end

    it "should reflect that it has been translated if one of its translations is complete" do
      expect(@video.translated?).to eq true
    end

    it "should reflect that it has been reviewed if one of its translations has been" do 
      expect(@video.reviewed?).to eq true
    end

    it "should correclty identify its reviewers" do
      expect(@video.reviewers).to include @user
    end

    it "an untranslated, unassigned video should declare that it is unassigned" do
      expect(Video.new.status).to eq :unassigned
    end

    it "an untranslated, assigned video should declare that it is assigned" do
      video = Video.create
      video.stub(:translations).and_return([Translation.new])
      expect(video.status).to eq :assigned
    end

    it "should not have any recently translated videos given restrictive paramters" do
      expect(Video.recently_translated_videos(Time.now)).to be_empty
    end
  end

  describe "link tests" do
    before(:each) do
      @video = FactoryGirl.create(:video)
      @video.amara_id = "invalidAmaraId"
    end

    it "should handle youtube requests appropriately" do
      expect(@video.youtube_link).to include @video.youtube_id
    end

    it "should handle amara requests appropriately" do
      expect(@video.amara_link).to include @video.amara_id
    end

    it "should not return an SRT link if the Amara id is invalid" do
      result = double('result')
      allow(result).to receive(:code) {'403'}
      Net::HTTP.stub(:get_response).and_return(result)
      expect(@video.amara_en_srt).to eq nil
    end

    it "should not return an srt link if the amara id is invalid" do
      result = double('result')
      allow(result).to receive(:code) {'302'}
      allow(result).to receive(:header) {{'location' => 'testlocation'}}
      allow(result).to receive(:body) {'<a href="body">SRT</a>'}
      Net::HTTP.stub(:get_response).and_return(result)
      expect(@video.amara_en_srt).to include 'body'
    end
  end

  describe "uploading CSV" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
    end

    it "should reject a missing file" do
      expect { Video.import(nil) }.to raise_error
    end 

    it "should reject a file with the wrong extension" do
      expect { Video.import("a.csv") }.to raise_error
    end 

    it "should correctly identify when translated are not recent" do
      @translation.stub(:complete?).and_return(true)
      @translation.time_last_updated = 1.day.ago
      expect(Video.recently_translated_videos(Time.now)).not_to include @video
    end
  end

  describe "Youtube video information" do
    # Use an existing video. If video changes, update here.
    let(:youtube_id) { 'm5kjb8xtdho' }

    let(:attributes) do
      {
        'title' => 'Top 10 Meryl Streep Performances',
        'description' => "She\'s always been more than just a pretty face.  Join http://www.WatchMojo.com as we count down our picks for the top 10 best Meryl Streep performances. Check us out at http://www.Twitter.com/WatchMojo, http://instagram.com/watchmojo and http://www.Facebook.com/WatchMojo \n\nSpecial thanks to our users sarahjessicaparkerth, Frank Morelli, Dave Ibraim, Mara Steinhardt, ri35ons, Andrew A. Dennison, JJ Herkenhoff, Hector Daniel Lovera Bautista and Lamichael Kelly for submitting the idea on our Suggestions Page at http://www.WatchMojo.com/suggest\n\nCheck out the voting page here, \nhttp://watchmojo.com/suggest/Top%2010%20Meryl%20Streep%20Performances\n\nIf you want to suggest an idea for a WatchMojo video, check out our interactive Suggestion Tool at http://www.WatchMojo.com/suggest :)\n\nWe have T-Shirts!  Be sure to check out http://www.WatchMojo.com/store for more info.",
        'duration' => 868
      }
    end

    it "grabs necessary details" do
      YoutubeReader::parse_video(youtube_id).should eq attributes
    end
  end
end
