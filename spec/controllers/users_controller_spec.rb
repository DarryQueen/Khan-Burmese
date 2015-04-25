require 'spec_helper'

describe UsersController do
  describe "normal user update" do
    login_user

    before(:each) do
      @user = User.find_by_email('normal@user.com')
      @admin = FactoryGirl.create(:admin)
    end

    it "can allow a user to update himself" do
      put 'update', :id => @user.id, :user => { :name => 'Casey Novak' }
      expect(@user.reload.name).to eq 'Casey Novak'
    end

    it "cannot allow a user to update someone else" do
      put 'update', :id => @admin.id, :user => { :name => 'Michonne' }
      expect(@admin.reload.name).to eq 'Carol Peletier'
    end

    it "should check for validations" do
      expect {
        put 'update', :id => @user.id, :user => { :email => '' }
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "admin user update" do
    login_admin

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = User.find_by_email('admin@user.com')
    end

    it "can allow an admin to update someone else" do
      put 'update', :id => @user.id, :user => { :name => 'Casey Novak' }
      expect(@user.reload.name).to eq 'Casey Novak'
    end
  end

  describe "leaderboard tests" do
    login_user

    before(:each) do
      @user = User.find_by_email('normal@user.com')
      @video = FactoryGirl.create(:video)
      @translation = Translation.create(:user => @user, :video => @video)
    end

    it "should not count untranslated videos as translated" do
      get 'leaderboard'
      expect(assigns(:translated_videos)).not_to include @video
    end
  end
end
