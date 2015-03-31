require 'spec_helper'

describe Video, :type => :model do
  describe "accessing translations and related users" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
    end

    it "should be able to access translations through video.translations" do
      expect {@video.translations}.not_to raise_error
      translations = @video.translations
      expect(translations).to include @translation
    end

    it "should be able to access users through video.translators" do
      expect {@video.translators}.not_to raise_error
      translators = @video.translators
      expect(translators).to include @user
    end
  end
end
