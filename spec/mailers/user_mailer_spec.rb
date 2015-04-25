require 'spec_helper'

describe UserMailer, :type => :model do
  describe "trivial email send" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
      @mail = UserMailer.translation_review_email(@translation, @user, 'Test')
    end

    it 'renders the subject' do
      expect(@mail.subject).to eql('Your Translation Has Been Reviewed')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@user.email])
    end
  end
end
