require 'spec_helper'

describe Identity, :type => :model do
  describe "find or create identities" do
    it "should find an existing identity" do
      facebook_id = FactoryGirl.create(:facebook_identity)

      auth = OpenStruct.new({
        :provider => facebook_id.provider,
        :uid => facebook_id.uid,
      })

      identity = Identity.find_for_oauth(auth)

      identity.should eq facebook_id
    end

    it "should create an identity if none exists corresponding to auth" do
      auth = OpenStruct.new({
        :provider => 'Tali\'zorah',
        :uid => 'vas Normandy',
      })

      expect {
        identity = Identity.find_for_oauth(auth)
      }.to change(Identity, :count).by(1)
    end
  end
end
