module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join("<br>")
    html = <<-HTML
    <div class="alert alert-danger" role="alert">
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
