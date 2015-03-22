module VideoHelper
  def toggle_star_button(video)
    i_starred = '<i class="fa fa-lg fa-star fa-starry fa-star-starred fa-fw"></i>'.html_safe
    i_unstarred = '<i class="fa fa-lg fa-star fa-starry fa-star-unstarred fa-fw"></i>'.html_safe

    html = ''
    if can? :star, video
      i_class = ''
      options = { :'data-method' => :put, :remote => true, :onclick => 'starClick(this);' }

      if video.starred
        i_class = i_starred
      else
        i_class = i_unstarred
      end

      html += link_to video_toggle_star_path(video), options do
        i_class
      end
    else
      if video.starred
        html += i_starred
      end
    end

    html.html_safe
  end
end
