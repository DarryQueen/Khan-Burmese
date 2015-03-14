class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_keys, :store_location, :authenticate_user!

  # Set post-login path to previous URL:
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    begin
      redirect_to :back, :flash => { :alert => exception.message }
    rescue ActionController::RedirectBackError
      redirect_to '/', :flash => { :alert => exception.message }
    end
  end

  private

  # Store last URL for post-login redirect:
  def store_location
    # We use a try/catch block for RailsAdmin.
    begin
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
    rescue
    end
  end

  # Check if API keys have been set:
  def check_keys
    return unless Rails.env.development?
    begin
      Figaro.require_keys('facebook_public_key', 'facebook_private_key', 'google_public_key', 'google_private_key')
    rescue Figaro::MissingKeys
      error_message = 'Warning! You haven\'t set your keys in <code>config/application.yml</code>!'
      if flash[:alert]
        flash.now[:alert] = flash.now[:alert].gsub(/#{error_message}(<br \/>)?/, '')
        flash.now[:alert] = ("#{error_message}<br />" + flash.now[:alert]).html_safe
      else
        flash.now[:alert] = error_message.html_safe
      end
    end
  end
end
