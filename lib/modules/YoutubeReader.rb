module YoutubeReader
  require 'net/http'

  def self.parse_video(youtube_id, timeout = 5)
    uri = URI.parse(data_link(youtube_id))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = timeout
    http.read_timeout = timeout
    request = http.get(uri.request_uri).body

    data = Hash.from_xml(request)['entry']

    attributes = {
      'title' => data['title'],
      'description' => data['group']['description'],
      'duration' => Integer(data['group']['duration']['seconds'])
    }
  end

  def self.data_link(youtube_id)
    "https://gdata.youtube.com/feeds/api/videos/#{youtube_id}?v=2"
  end
end
