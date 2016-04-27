module YoutubeReader
  require 'net/http'
  require 'nokogiri'
  require 'open-uri'

  def self.parse_video(youtube_id, timeout = 5)
    uri = URI.parse(data_link(youtube_id))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = timeout
    http.read_timeout = timeout
    request = http.get(uri.request_uri).body

    data = Hash.from_xml(request)['entry']

    raise ArgumentError, 'Invalid Youtube ID' if data.nil?

    attributes = {
      'title' => data['title'],
      'description' => data['group']['description'],
      'duration' => Integer(data['group']['duration']['seconds'])
    }
  end

  def self.amara_id(youtube_id)
    youtube_url = "\"https://www.youtube.com/watch?v=#{youtube_id}\""
    video_url = "https://www.amara.org/widget/rpc/jsonp/show_widget?video_url=#{URI::encode(youtube_url)}&is_remote=true"
    response = Nokogiri::HTML(open(video_url).read)

    /"video_id"[^"]*"([^"]*)"/.match(response.text)[1]
  end

  def self.data_link(youtube_id)
    "https://gdata.youtube.com/feeds/api/videos/#{youtube_id}?v=2"
  end
end
