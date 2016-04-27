require 'spec_helper'
require 'factories'

describe User, :type => :model do
  include_context 'factories'

  describe "naming schematics" do
    let!(:user) do
      User.new({
        :email => 'normal@user.com',
        :password => 'password'
      })
    end

    it "should split first and last names" do
      user.name = 'lady Gaga'
      user.save

      user.name.should eq 'Lady Gaga'
      user.first_name.should eq 'Lady'
      user.last_name.should eq 'Gaga'
    end

    it "should accept mononyms" do
      user.name = 'madonna'
      user.save

      user.first_name.should eq 'Madonna'
      user.last_name.should eq 'Madonna'
    end
  end

  describe "find identities for users" do
    it "should find the facebook identity" do
      auth = OpenStruct.new({
        :provider => 'facebook',
        :uid => 'liara',
        :info => OpenStruct.new({ :email => user.email, :name => 'Liara T\'Soni' })
      })

      Identity.stub(:find_for_oauth => facebook_id)

      User.find_for_oauth(auth, user)

      facebook_id.user.should be user
    end

    it "creates a user if none exists corresponding to the identity" do
      auth = OpenStruct.new({
        :provider => 'facebook',
        :uid => 'liara',
        :info => OpenStruct.new({ :email => 'miranda@lawson.com', :name => 'Liara T\'Soni' })
      })

      Identity.stub(:find_for_oauth => facebook_id)

      expect {
        User.find_for_oauth(auth)
      }.to change(User, :count).by(1)
    end
  end

  describe "accessing translations and related videos" do
    before(:each) do
      translation
    end

    it "should be able to access translations through user.translations" do
      expect { user.translations }.not_to raise_error
      expect(user.translations).to include translation
    end

    it "should be able to access videos through user.translation_videos" do
      expect { user.translation_videos }.not_to raise_error
      expect(user.translation_videos).to include video
    end

    it "should dynamically update translated and untranslated videos" do
      expect(user.assigned_videos).to include video
      expect(user.translated_videos).not_to include video
    end
  end

  describe "leaderboard and points tests" do
    let(:year_t) { Translation.new }
    let(:month_t) { Translation.new }
    let(:old_t) { Translation.new }

    before(:each) do
      year_t.stub(:status_symbol).and_return(:complete_with_priority)
      year_t.stub(:status_symbol).and_return(:complete)
      year_t.stub(:status_symbol).and_return(:incomplete)
      year_t.stub(:time_updated).and_return(40.days.ago)
      month_t.stub(:time_updated).and_return(20.days.ago)
      old_t.stub(:time_updated).and_return(2.years.ago)

      allow(user).to receive(:translations).and_return([year_t, month_t, old_t])   
    end

    it "should calculate all_time points correctly" do
      expect(user.points).to eq(year_t.points + month_t.points + old_t.points)
    end

    it "should calculate year points correctly" do
      expect(user.points(1.year.ago)).to eq(year_t.points + month_t.points)
    end

    it "should calculate month points correctly" do
      expect(user.points(1.month.ago)).to eq(month_t.points)
    end
  end

  describe "video methods" do
    it "should return the correct assigned videos" do
      allow(translation).to receive(:complete?).and_return(false)
      expect(user.assigned_videos).to include video
    end
  end

  describe "basic methods" do
    it "should return the correct first name" do
      expect(user.first_name).to eq 'Olivia'
    end

    it "should return the correct last name" do
      expect(user.last_name).to eq 'Benson'
    end

    it "should identify a defalut user's role correclty" do
      user.assign_default_role
      expect(user.is?('volunteer')).to eq true
    end

    it "should check for email verficiation correctly" do
      expect(user.email_verified?).to eq true
      user.email = nil
      expect(user.email_verified?).not_to eq true
    end

    it "should capitalize fields correctly in after_safe" do
      user.country = "united states"
      expect(user.country).to eq "united states"
      user.save
      expect(user.country).to eq "United States"
    end
  end
end
