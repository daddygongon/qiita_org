require "colorize"
require "io/console"
require "qiita_org/get_file_path.rb"
require "qiita_org/show_file_and_url.rb"

class UpLoad
  def initialize(src, option, os)
    @src = src
    @option = (option == "qiita" || option == "open")? "public" : option
    @os = os
  end

  def upload()
    paths = GetFilePath.new(@src).get_file_path()
    unless paths.empty?
      showfile = ShowFile.new(paths, @src, @option, @os)
      showfile.open_file_dir()
      showfile.open_qiita()

      puts "Overwrite file URL's on #{@src}? (y/n)".green
      ans = STDIN.getch

      if ans == "y"
        showfile.input_url_to_org()
      end
    end
  end
end
