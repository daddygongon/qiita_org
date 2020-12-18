require "net/https"
require "json"
require "open-uri"
require "colorize"
require "qiita_org/error_message.rb"
require "qiita_org/access_qiita.rb"

class QiitaList
  def initialize(mode)
    @mode = mode
    @base = QiitaBase.new
    @access_token, @teams_url, @display, @ox_qmd_load_path = @base.set_config()
    if @mode == "teams"
      ErrorMessage.new().teams_url_error(@teams_url)
    end

    @qiita, @path = @base.select_access_path(@mode, @teams_url)
    @items = AccessQiita.new(@access_token, @qiita, @path).access_qiita()
    view_list()
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
  end
end
