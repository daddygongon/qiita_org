require "net/https"
require "json"
require "open-uri"
require "colorize"
require "qiita_org/search_conf_path.rb"

class QiitaList
  def initialize(mode)
    @mode = mode
    search = SearchConfPath.new(Dir.pwd, Dir.home)
    @conf_dir = search.search_conf_path()
    set_config()
    select_path()
    access_qiita()
    view_list()
  end

  def set_config()
    conf_path = File.join(@conf_dir, ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    @access_token = conf["access_token"]
    @teams_url = conf["teams_url"]
  end

  # select path
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

  # access qiita
  def access_qiita()
    uri = URI.parse(@qiita + @path)

    headers = { "Authorization" => "Bearer #{@access_token}",
      "Content-Type" => "application/json" }

    response = URI.open(
                        "#{uri}",
                        "Authorization" => "#{headers["Authorization"]}",
                        )
    @items = JSON.parse(response.read)
  end

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
