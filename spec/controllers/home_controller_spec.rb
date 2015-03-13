require 'spec_helper'

describe HomeController do
  describe "user logged in" do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    it "should not redirect" do
      get 'index'
      response.should_not eq(302)
    end
  end
end
