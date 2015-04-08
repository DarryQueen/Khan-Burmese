require 'spec_helper'

describe User, :type => :model do
  describe "naming schematics" do
    before(:each) do
      @user = User.new({
        :email => 'normal@user.com',
        :password => 'password'
      })
    end

    it "should split first and last names" do
      @user.name = 'lady Gaga'
      @user.save

      @user.name.should eq 'Lady Gaga'
      @user.first_name.should eq 'Lady'
      @user.last_name.should eq 'Gaga'
    end

    it "should accept mononyms" do
      @user.name = 'madonna'
      @user.save

      @user.first_name.should eq 'Madonna'
      @user.last_name.should eq 'Madonna'
    end
  end

  describe "find identities for users" do
    it "should find the facebook identity" do
      user = FactoryGirl.create(:user)
      facebook_id = FactoryGirl.create(:facebook_identity)

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
      facebook_id = FactoryGirl.create(:facebook_identity)

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
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
    end

    it "should be able to access translations through user.translations" do
      expect {@user.translations}.not_to raise_error
      translations = @user.translations
      expect(translations).to include @translation
    end

    it "should be able to access videos through user.translation_videos" do
      expect {@user.translation_videos}.not_to raise_error
      videos = @user.translation_videos
      expect(videos).to include @video
    end

    it "should dynamically update translated and untranslated videos" do
      expect(@user.untranslated_videos).to include @video
      expect(@user.translated_videos).not_to include @video
    end
  end
end
