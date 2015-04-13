class UserMailer < ActionMailer::Base
  default :from => 'khanburmese@gmail.com'
  layout 'layouts/email'

  def translation_review_email(translation, reviewer, message)
    @translation = translation
    @user = translation.user
    @reviewer = reviewer
    @message = message
    @video = translation.video
    mail(:to => @user.email, :subject => 'Your Translation Has Been Reviewed')
  end
end
