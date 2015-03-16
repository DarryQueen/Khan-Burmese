module ApplicationHelper
  # Helper method for adding flash messages:
  def add_flash(key, message, options = {})
    add_to = options[:now] ? flash.now[key] : flash[key]
    add_to ||= []
    add_to = [add_to] unless add_to.kind_of?(Array)

    index = options[:beginning] ? 0 : -1
    add_to.insert(index, message) unless add_to.include?(message)

    options[:now] ? flash.now[key] = add_to : flash[key] = add_to
  end

  # Helper method for rendering flash messages:
  def render_flash(key)
    if flash[key].kind_of?(Array)
      flash[key].join('<br />').html_safe
    else
      flash[key].html_safe
    end
  end
end
