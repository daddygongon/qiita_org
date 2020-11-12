require "net/https"
require "json"
require "open-uri"
require "colorize"
require "qiita_org/select_path.rb"
require "qiita_org/set_config.rb"
require "qiita_org/error_message.rb"
require "qiita_org/access_qiita.rb"

class QiitaList
  def initialize(mode)
    @mode = mode
    @access_token, @teams_url, @ox_qmd_load_path = SetConfig.new().set_config()
    if @mode == "teams"
      ErrorMessage.new().teams_url_error(@teams_url)
    end

    @qiita, @path = SelectPath.new().select_path(@mode, @teams_url)
    @items = AccessQiita.new(@access_token, @qiita, @path).access_qiita()
    view_list()
  end

  # select path
=begin
  def select_path()
    case @mode
    when "teams"
      @qiita = @teams_url
      @path = "api/v2/items?page=1&per_page=100"
    else
      @qiita = "https://qiita.com/"
      @path = "api/v2/authenticated_user/items?page=1&per_page=100"
    end
  end
=end

  # access qiita
=begin
  def access_qiita()
    uri = URI.parse(@qiita + @path)

    headers = { "Authorization" => "Bearer # {@access_token}",
      "Content-Type" => "application/json" }

    response = URI.open(
                        "# {uri}",
                        "Authorization" => "# {headers["Authorization"]}",
                        )
    @items = JSON.parse(response.read)
  end
=end

  def view_list()
    @items.each do |item|
      puts "title: #{item["title"]}"
      puts "Author: #{item["user"]["id"]}" if @mode == "teams"
      puts "URL: #{item["url"]}"
      body = item["body"]
      source = body.match(/- \**source\** ~(.+)/)
      if source != nil
        puts "Source: ~#{source[1]}"
      end
      puts ""
    end
#    p @items[0]["user"]["id"]
  end
end
