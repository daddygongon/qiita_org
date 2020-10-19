require "net/https"
require "json"
require "open-uri"
require "io/console"
require "colorize"
require "qiita_org/search_conf_path.rb"

class GetFileUrl
  def initialize(id, file, mode)
    @id = id
    @file = file
    @mode = (mode == "qiita" || mode == "open")? "public" : mode
    search = SearchConfPath.new(Dir.pwd, Dir.home)
    @conf_dir = search.search_conf_path()
    set_config()
  end

  def set_config()
    conf_path = File.join(@conf_dir, ".qiita.conf")
    @conf = JSON.load(File.read(conf_path))
    @access_token = @conf["access_token"]
    @teams_url = @conf["teams_url"]
  end

  def get_file_url()
    qiita = (@mode == "teams")? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{@id}"

    items = access_qiita(@access_token, qiita, path)

    file_url = items["body"].match(/\!\[#{@file}\]\(((.+))\)/)[2]
    return file_url

    #File.write("url_text.md", items["body"])
  end

  def access_qiita(access_token, qiita, path)
    uri = URI.parse(qiita + path)

    headers = { "Authorization" => "Bearer #{access_token}",
                "Content-Type" => "application/json" }

    response = URI.open(
      "#{uri}",
      "Authorization" => "#{headers["Authorization"]}",
    )
    items = JSON.parse(response.read)
    return items
  end
end
