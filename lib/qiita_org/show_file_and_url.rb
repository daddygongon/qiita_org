require "colorize"
require "qiita_org/get_file_url.rb"

class ShowFile
  def initialize(paths, src, mode)
    @paths = paths
    @src = src
    @mode = (mode == "qiita" || mode == "open")? "public" : mode
  end

  def open_file_dir()
    previous_paths = []
    previous_paths << File.join(@paths[0].split("/")[0..-2])
    system "open #{File.join(@paths[0].split("/")[0..-2])}"
    @paths.each do |path|
      dir_path = File.join(path.split("/")[0..-2])
      unless previous_paths.include?(dir_path)
        previous_paths << dir_path
        system "open #{dir_path}"
      end
    end
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
          lines[i] = "[[file:#{path}][#{url}]]\n"
        end
      end
    end
    #p lines
    File.write(@src, lines.join)
  end
end
