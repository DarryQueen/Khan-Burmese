require 'spec_helper'

describe User, :type => :model do
  describe "find identities for users" do
    it "should find the facebook identity" do
      user = FactoryGirl.create(:user)
      facebook_id = FactoryGirl.create(:facebook_identity)

      auth = OpenStruct.new({
        :provider => 'facebook',
        :uid => 'liara',
        :info => OpenStruct.new({ :email => user.email })
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
        :info => OpenStruct.new({ :email => 'miranda@lawson.com' })
      })

      Identity.stub(:find_for_oauth => facebook_id)

      expect {
        User.find_for_oauth(auth)
      }.to change(User, :count).by(1)
    end
  end
end
