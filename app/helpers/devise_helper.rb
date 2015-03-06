module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join('<br />')

    # html.html_safe
    if flash.now[:alert]
      flash.now[:alert] += '<br />'.html_safe
    else
      flash.now[:alert] = ''.html_safe
    end
    flash.now[:alert] += messages.html_safe
  end
end
