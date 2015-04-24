require 'spec_helper'
require 'cancan/matchers'

describe VideoHelper, :type => :module do
  describe "unit testing methods" do
    it "should assign the correct colors based on status" do
      expect(status_to_color('reviewed')).to eq 'success'
    end

    it "score_badge tests" do
      expect(score_badge(-1).to_s.include? 'danger').to eq true
    end
  end
end
