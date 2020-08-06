# -*- coding: utf-8 -*-
#+begin_src ruby -n
require "net/https"
require "json"
require "command_line/global"

class QiitaPost
  def initialize(file, option)
    @src = file
    @option = (option == "open")? "qiita" : option
  end

  def get_title_tags()
    @conts = File.read(@src)
    @title = @conts.match(/\#\+(TITLE|title|Title): (.+)/)[2] || "テスト"
    m = []
    @tags = if m = @conts.match(/\#\+(TAG|tag|Tag|tags|TAGS|Tags): (.+)/)
        m[2].split(",").inject([]) do |l, c|
          l << { name: c.strip } #, versions: []}
        end
      else
        [{ name: "hoge" }] #, versions: [] }]
      end
    p @tags
  end

  def set_config()
    conf_path = File.join(ENV["HOME"], ".qiita.conf")
    @conf = JSON.load(File.read(conf_path))
    @access_token = @conf["access_token"]
    @teams_url = @conf["teams_url"]
    @ox_qmd_load_path = @conf["ox_qmd_load_path"]
  end

  # src.org -> src.md
  def convert_org_to_md()
    command = "emacs #{@src} --batch -l #{@ox_qmd_load_path} -f org-qmd-export-to-markdown --kill"
    res = command_line command
    p res
  end

  # add source path in md
  def add_source_path_in_md()
    @lines = File.readlines(@src.gsub(".org", ".md"))
    path = Dir.pwd.gsub(ENV["HOME"], "~")
    @lines << "------\n - **source** #{path}/#{@src}\n"
  end

  # patch or post selector by qiita_id
  def select_patch_or_post()
    m = []
    @patch = false
    if m = @conts.match(/\#\+#{@option}_id: (.+)/)
      @qiita_id = m[1]
      @patch = true
    else
      @qiita_id = ""
    end
  end

  def select_option(option)
    case option
    when "teams"
      qiita = @teams_url
      private = false
    when "qiita"
      qiita = "https://qiita.com/"
      private = false
    else
      qiita = "https://qiita.com/"
      private = true
    end
    return [qiita, private]
  end

  # qiita post
  def qiita_post()
    params = {
      "body": @lines.join, #"# テスト",
      "private": @private,
      "title": @title,
      "tags": @tags,
    }

    if @patch
      @path = "api/v2/items/#{@qiita_id}"
    else
      @path = "api/v2/items"
    end
    p ["qiita", @qiita]
    p ["path", @path]
    p @qiita + @path
    uri = URI.parse(@qiita + @path)

    http_req = Net::HTTP.new(uri.host, uri.port)
    http_req.use_ssl = uri.scheme === "https"

    headers = { "Authorization" => "Bearer #{@access_token}",
                "Content-Type" => "application/json" }
    if @patch
      @res = http_req.patch(uri.path, params.to_json, headers)
    else
      @res = http_req.post(uri.path, params.to_json, headers)
    end
  end

  # qiita return
  def get_and_print_qiita_return()
    p @res.message

    @res_body = JSON.parse(@res.body)
    @res_body.each do |key, cont|
      if key == "rendered_body" or key == "body"
        puts "%20s brabrabra..." % key
        next
      end
      print "%20s %s\n" % [key, cont]
    end
  end

  # add qiita_id on src.org
  def add_qiita_id_on_org()
    @qiita_id = @res_body["id"]
    unless @patch
      File.write(@src, "#+#{@option}_id: #{@qiita_id}\n" + @conts)
    end
  end

  def run()
    get_title_tags()
    set_config()
    convert_org_to_md()
    add_source_path_in_md()
    select_patch_or_post()
    @qiita, @private = select_option(@option)
    qiita_post()
    get_and_print_qiita_return()

    # open qiitta
    system "open #{@res_body["url"]}"

    add_qiita_id_on_org()
  end
end

#+end_src
