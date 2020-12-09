require "colorize"
require "io/console"
#require "qiita_org/get_file_path.rb"
#require "qiita_org/show_file_and_url.rb"
require "qiita_org/file_open.rb"
#require "qiita_org/set_config.rb"
require "qiita_org/access_qiita.rb"

class QiitaFileUpLoad
  def initialize(src, option, os)
    @src = src
    @option = (option == "qiita" || option == "open")? "public" : option
    @os = os
    @fileopen = FileOpen.new(@os)
    # @access_token, @teams_url, @display, @ox_qmd_load_path = SetConfig.new().set_config()
    @access_token, @teams_url, @display, @ox_qmd_load_path = QiitaBase.new().set_config()
    if @option == "teams"
      ErrorMessage.new().teams_url_error(@teams_url)
    end
  end

  def upload()
    #paths = GetFilePath.new(@src).get_file_path()
    paths = get_file_path(@src)
    unless paths.empty?
      #showfile = ShowFile.new(paths, @src, @option, @os)
      #showfile.open_file_dir()
      open_file_dir(paths)
      #showfile.open_qiita()
      open_qiita()

      puts "Overwrite file URL's on #{@src}? (y/n)".green
      ans = STDIN.getch

      if ans == "y"
        #showfile.input_url_to_org()
        input_url_to_org(paths)
      end
    else
      puts "file path is empty.".red
    end
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
    previous_paths << File.join(paths[0].split("/")[0..-2])
    @fileopen.file_open(File.join(paths[0].split("/")[0..-2]))

    paths.each do |path|
      dir_path = File.join(path.split("/")[0..-2])
      unless previous_paths.include?(dir_path)
        previous_paths << dir_path
        @fileopen.file_open(dir_path)
      end
    end
  end

  def open_qiita()
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@option}: (.+)/)[1]

=begin
    @access_token, @teams_url, @display, @ox_qmd_load_path = SetConfig.new().set_config()
    if @option == "teams"
      ErrorMassage.new().teams_url_error(@teams_url)
    end
=end

    qiita = (@option == "teams") ? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{id}"

    @access = AccessQiita.new(@access_token, qiita, path)
    items = @access.access_qiita()

    @fileopen.file_open(items["url"])
  end

  def input_url_to_org(paths)
    lines = File.readlines(@src)
    conts = File.read(@src)
    id = conts.match(/\#\+qiita_#{@option}: (.+)/)[1]

    paths.each do |path|
      file_name = File.basename(path).strip
      url = (get_file_url(id, file_name))? @file_url : next
      lines.each_with_index do |line, i|
        if line.match(/\[\[file:#{path}\]\]/)
          lines[i] = "[[#{url}][file:#{path}]]\n"
        end
      end
    end

    File.write(@src, lines.join)
  end

  def get_file_url(id, file_name)
    qiita = (@option == "teams")? @teams_url : "https://qiita.com/"
    path = "api/v2/items/#{@id}"

    items = @access.access_qiita()

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
