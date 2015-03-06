require 'spec_helper'
require 'cancan/matchers'

describe Ability, :type => :model do
  describe "trivial creation" do
    it "creates powerful ability if admin passed in" do
      admin = FactoryGirl.create(:admin)
      ability = Ability.new admin

      ability.should be_able_to(:manage, User)
    end

    it "creates weak user if non-admin passed in" do
      user = FactoryGirl.create(:user)
      ability = Ability.new user

      ability.should_not be_able_to(:manage, User)
    end
  end
end
