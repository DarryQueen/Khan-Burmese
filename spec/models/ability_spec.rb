require 'spec_helper'
require 'cancan/matchers'
require 'factories'

describe Ability, :type => :model do
  include_context 'factories'

  describe "trivial creation" do
    it "creates powerful ability if admin passed in" do
      ability = Ability.new admin

      ability.should be_able_to(:manage, User)
    end

    it "creates weak user if non-admin passed in" do
      ability = Ability.new user

      ability.should_not be_able_to(:manage, User)
    end
  end
end
