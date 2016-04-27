require 'spec_helper'
require 'factories'

describe UsersController do
  include_context 'factories'

  describe "normal user update" do
    login_user

    it "can allow a user to update himself" do
      put 'update', :id => user.id, :user => { :name => 'Casey Novak' }
      expect(user.reload.name).to eq 'Casey Novak'
    end

    it "cannot allow a user to update someone else" do
      put 'update', :id => admin.id, :user => { :name => 'Michonne' }
      expect(admin.reload.name).to eq 'Carol Peletier'
    end

    it "should check for validations" do
      expect {
        put 'update', :id => user.id, :user => { :email => '' }
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "admin user update" do
    login_admin

    it "can allow an admin to update someone else" do
      put 'update', :id => user.id, :user => { :name => 'Casey Novak' }
      expect(user.reload.name).to eq 'Casey Novak'
    end
  end

  describe "leaderboard tests" do
    login_user

    before(:each) do
      translation
    end

    it "should not count untranslated videos as translated" do
      get 'leaderboard'
      expect(assigns(:translated_videos)).not_to include video
    end
  end

  describe "delete user" do
    login_admin

    it "should delete a user with complete translation" do
      allow(translation).to receive(:complete?).and_return(false)
      delete 'destroy', :id => user.id
      deleted_user = User.find_by_id(user.id)
      expect(deleted_user).to be_nil
      deleted_translation = Translation.find_by_id(translation.id)
      expect(deleted_translation).to be_nil
    end
  end
end
