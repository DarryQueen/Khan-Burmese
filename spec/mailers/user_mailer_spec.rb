require 'spec_helper'
require 'factories'

describe UserMailer, :type => :model do
  include_context 'factories'

  describe "trivial email send" do
    let(:mail) { UserMailer.translation_review_email(translation, user, 'Test') }

    it 'renders the subject' do
      expect(mail.subject).to eql('Your Translation Has Been Reviewed')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
  end
end
