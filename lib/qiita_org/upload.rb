require "colorize"
require "io/console"
require "qiita_org/access_qiita.rb"

class QiitaFileUpLoad
  def initialize(src, option, os = "mac")
    p @src = src
    @option = (option == "qiita" || option == "open") ? "public" : option
    @os = os
    @base = QiitaBase.new()
    @access_token, @teams_url, @display, @ox_qmd_load_path, @insert_source = QiitaBase.new().set_config()
    ErrorMessage.new().teams_url_error(@teams_url) if @option == "teams"
  end

  def upload()
    paths = get_file_path(@src)
    if paths.empty?
      raise RuntimeError.new "No upload file path in #{@src}."
    else
      open_file_dir(paths)
      open_qiita()

      puts "Overwrite file URL's on #{@src}? (y/n)".green
      ans = STDIN.getch

      input_url_to_org(paths) if ans[0].downcase == "y"
    end
    true
  end

  def get_file_path(src)
    lines = File.readlines(src)
    files = []
    lines.each do |line|
      if path = line.match(/\[\[(.+)\]\[file:(.+)\]\]/) || line.match(/\[\[file:(.+)\]\]/)
        if path[2] == nil
          files << path[1]
        else
          files << path[2]
        end
      end
    end

    return files
  end

  def open_file_dir(paths)
    previous_paths = []
    #    previous_paths << File.join(paths[0].split("/")[0..-2])
    #    @base.file_open(@os, File.join(paths[0].split("/")[0..-2]))

    [paths].flatten.each do |path| # previous need for ommit multiple open of the identical dir
      dir_path = File.join(path.split("/")[0..-2])
      dir_path = "." if dir_path == ""
      unless previous_paths.include?(dir_path)
        previous_paths << dir_path
        @base.file_open(@os, dir_path)
      end
    end
  end

  def open_qiita()
    id = QiitaBase.new().get_report_id(@src, @option)

    qiita = (@option == "teams") ? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{id}"

    @access = AccessQiita.new(@access_token, qiita, path)
    items = @access.access_qiita()

    @base.file_open(@os, items["url"])
  end

  def input_url_to_org(paths)
    lines = File.readlines(@src)
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@option}: (.+)/)[1]

    paths.each do |path|
      file_name = File.basename(path).strip
      #url = (get_file_url(id, file_name)) ? @file_url : next
      if get_file_url(id, file_name)
        url = @file_url
      else
        next
      end
      lines.each_with_index do |line, i|
        if line.match(/\[\[file:#{path}\]\]/)
          lines[i] = "[[#{url}][file:#{path}]]\n"
        end
      end
    end

    File.write(@src, lines.join)
  end

  def get_file_url(id, file_name)
    qiita = (@option == "teams") ? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{@id}"

    items = @access.access_qiita()
    puts items["body"].match?(/\!\[#{file_name}\]\(((.+))\)/)
    if items["body"].match?(/\!\[#{file_name}\]\(((.+))\)/)
      @file_url = items["body"].match(/\!\[#{file_name}\]\(((.+))\)/)[2]
      puts "Wrote #{file_name}'s URL".green
      return true
    else
      puts "Can not find #{file_name}'s URL".red
      return false
    end
  end
end
