module YoutubeReader
  require 'net/http'
  require 'nokogiri'
  require 'open-uri'

  INTERVAL_MULTIPILERS = [1, 60, 60 * 60, 60 * 60 * 24]

  def self.parse_video(youtube_id, timeout = 5)
    uri = URI.parse(self.data_link(youtube_id))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = timeout
    http.read_timeout = timeout
    request = http.get(uri.request_uri).body

    data = JSON.parse(request)['items'].first

    raise ArgumentError, 'Invalid Youtube ID' if data.nil?

    attributes = {
      'title' => data['snippet']['localized']['title'],
      'description' => data['snippet']['localized']['description'],
      'duration' => self.yt_duration_to_int(data['contentDetails']['duration'])
    }
  end

  def self.amara_id(youtube_id)
    youtube_url = "\"https://www.youtube.com/watch?v=#{youtube_id}\""
    video_url = "https://www.amara.org/widget/rpc/jsonp/show_widget?video_url=#{URI::encode(youtube_url)}&is_remote=true"
    response = Nokogiri::HTML(open(video_url).read)

    /"video_id"[^"]*"([^"]*)"/.match(response.text)[1]
  end

  private

  def self.yt_duration_to_int(yt_duration)
    times = yt_duration.sub('PT', '').split(/[^0-9]/)

    duration = 0
    times.reverse.each_with_index do |time, index|
      duration += Integer(time) * INTERVAL_MULTIPILERS[index]
    end

    duration
  end

  def self.data_link(youtube_id)
    "https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=#{youtube_id}&key=#{ENV['youtube_api_key']}"
  end
end
