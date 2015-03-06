class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if user_signed_in?
      flash.keep
      redirect_to after_login_path
    end
  end
end
