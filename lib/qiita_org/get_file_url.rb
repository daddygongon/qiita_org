require "net/https"
require "json"
require "open-uri"
require "io/console"
require "colorize"
require "qiita_org/set_config.rb"
require "qiita_org/error_massage.rb"
require "qiita_org/access_qiita.rb"

class GetFileUrl
  def initialize(id, file, mode)
    @id = id
    @file = file
    @mode = (mode == "qiita" || mode == "open")? "public" : mode
    @access_token, @teams_url, @ox_qmd_load_path = SetConfig.new().set_config()
    if @mode == "teams"
      ErrorMassage.new().teams_url_error(@teams_url)
    end
  end

  def get_file_url()
    qiita = (@mode == "teams")? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{@id}"

    items = AccessQiita.new(@access_token, qiita, path).access_qiita()

    file_url = items["body"].match(/\!\[#{@file}\]\(((.+))\)/)[2]
    return file_url

    #File.write("url_text.md", items["body"])
  end

=begin
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
=end
end
