require "colorize"
require "qiita_org/get_file_url.rb"
require "qiita_org/set_config.rb"
require "qiita_org/access_qiita.rb"
require "qiita_org/file_open.rb"

class ShowFile
  def initialize(paths, src, mode, os)
    @paths = paths
    @src = src
    @mode = (mode == "qiita" || mode == "open") ? "public" : mode
    @os = os
    @fileopen = FileOpen.new(@os)
  end

  def open_file_dir()
    previous_paths = []
    previous_paths << File.join(@paths[0].split("/")[0..-2])
    @fileopen.file_open(File.join(@paths[0].split("/")[0..-2]))

    #    if @os == "mac"
    #      system "open # {File.join(@paths[0].split("/")[0..-2])}"
    #    elsif @os == "windows"
    #      system "explorer.exe # {File.join(@paths[0].split("/")[0..-2])}"
    #    else
    #      system "open # {File.join(@paths[0].split("/")[0..-2])}"
    #      system "xdg-open # {File.join(@paths[0].split("/")[0..-2])}"
    #    end

    @paths.each do |path|
      dir_path = File.join(path.split("/")[0..-2])
      unless previous_paths.include?(dir_path)
        previous_paths << dir_path
        #system "open # {dir_path}"
        @fileopen.file_open(dir_path)

        #        if @os == "mac"
        #          system "open # {dir_path}"
        #        elsif @os == "windows"
        #          system "explorer.exe # {dir_path}"
        #        else
        #          system "open # {dir_path}"
        #          system "xdg-open # {dir_path}"
        #        end
      end
    end
  end

  def open_qiita()
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@mode}: (.+)/)[1]

    @access_token, @teams_url, @ox_qmd_load_path = SetConfig.new().set_config()
    if @mode == "teams"
      ErrorMassage.new().teams_url_error(@teams_url)
    end

    qiita = (@mode == "teams") ? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{id}"

    items = AccessQiita.new(@access_token, qiita, path).access_qiita()

    @fileopen.file_open(items["url"])
=begin
    if @os == "mac"
      system "open # {items["url"]}"
    elsif @os == "windows"
      system "explorer.exe # {items["url"]}"
    else
      system "open # {items["url"]}"
      system "xdg-open # {items["url"]}"
    end
=end
  end

  def show_file_url()
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@mode}: (.+)/)[1]

    @paths.each do |path|
      file_name = File.basename(path).strip
      geturl = GetFileUrl.new(id, file_name, @mode)
      url = geturl.get_file_url()
      puts "#{file_name}'s URL".green
      puts url
    end
  end

  def input_url_to_org()
    lines = File.readlines(@src)
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@mode}: (.+)/)[1]

    @paths.each do |path|
      file_name = File.basename(path).strip
      geturl = GetFileUrl.new(id, file_name, @mode)
      url = geturl.get_file_url()
      lines.each_with_index do |line, i|
        if line.match(/\[\[file:#{path}\]\]/)
          #lines[i] = "[[file:# {path}][# {url}]]\n"
          lines[i] = "[[#{url}][file:#{path}]]\n"
        end
      end
    end
    #p lines
    File.write(@src, lines.join)
  end

=begin
  def access_qiita(access_token, qiita, path)
    uri = URI.parse(qiita + path)

    headers = { "Authorization" => "Bearer #{access_token}",
                "Content-Type" => "application/json" }

    response = URI.open(
      "# {uri}",
      "Authorization" => "# {headers["Authorization"]}",
    )
    items = JSON.parse(response.read)
    return items
  end
=end
end
