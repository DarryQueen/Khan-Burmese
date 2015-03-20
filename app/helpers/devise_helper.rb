module DeviseHelper
  include ApplicationHelper

  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages
    messages.each { |message| add_flash(:alert, message, :now => true) }
    ''
  end
end
