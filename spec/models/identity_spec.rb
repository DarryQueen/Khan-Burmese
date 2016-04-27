require 'spec_helper'
require 'factories'

describe Identity, :type => :model do
  include_context 'factories'

  describe "find or create identities" do
    it "should find an existing identity" do
      auth = OpenStruct.new({
        :provider => facebook_id.provider,
        :uid => facebook_id.uid,
      })

      Identity.find_for_oauth(auth).should eq facebook_id
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
