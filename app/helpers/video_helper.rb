module VideoHelper
  def toggle_star_button(video)
    i_starred = '<i class="fa fa-lg fa-star fa-star-starred fa-fw"></i>'.html_safe
    i_unstarred = '<i class="fa fa-lg fa-star fa-star-unstarred fa-fw"></i>'.html_safe

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

  def toggle_vote_button(vote, video, translation, options = {})
    voted = current_user.voted_as_when_voted_on(translation) == vote

    vote_class = vote ? 'upvote' : 'downvote'

    icon_class = vote ? 'fa-sort-asc' : 'fa-sort-desc'
    icon_class += ' active' if voted

    content_tag :span, :class => 'vote' do
      link_to('', video_translation_vote_path(video, translation, :vote => vote), {
        :'data-method' => :post,
        :remote => true,
        :class => "#{vote_class}-link"
      }.merge(options)) + "<i class=\"fa fa-lg #{icon_class} #{vote_class}\"></i>".html_safe
    end
  end

  def score_badge(score)
    badge_class = 'badge vote-badge'
    badge_class += ' danger' if score < 0

    content_tag :span, score, :class => badge_class
  end

  def status_to_color(status)
    case status.to_s
    when 'unassigned' then 'danger'
    when 'assigned' then 'warning'
    when 'translated' then 'primary'
    when 'reviewed' then 'success'
    end
  end
end
