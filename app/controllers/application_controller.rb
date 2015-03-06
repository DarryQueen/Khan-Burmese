class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location, :authenticate_user!

  # Set post-login path to previous URL:
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to :back
  end

  private

  # Store last URL for post-login redirect:
  def store_location
    return unless request.get?

    ignore_paths = [
      user_omniauth_authorize_path(:provider => 'facebook'),
      user_omniauth_authorize_path(:provider => 'google_oauth2'),
      new_user_session_path, new_user_registration_path,
      new_user_password_path, edit_user_password_path,
      destroy_user_session_path
    ]

    return if request.xhr? or request.path.match(Regexp.union(ignore_paths))
    session[:previous_url] = request.fullpath
  end
end
