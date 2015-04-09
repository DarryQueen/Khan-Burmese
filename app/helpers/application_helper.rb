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

  def seconds_to_string(seconds)
    return '0' unless seconds

    h = (seconds / 3600).to_s
    m = (seconds / 60 % 60).to_s
    s = (seconds % 60).to_s.rjust(2, '0')

    times = []
    if h != '0'
      times.push(h)
      m = m.to_s.rjust(2, '0')
    end
    times.push(m, s)
    times.join(':')
  end
end
