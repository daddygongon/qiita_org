require "colorize"

class QiitaAll
  def initialize(argv)
    check_options(argv)
    @files = Dir.glob("*.org")
    p @files
  end

  def run()
    @files.each do |file|
      unless @exclude_files.empty?
        next if @exclude_files.include?(file)
        #if @exclude_files.include?(file)
         # next
        #end
      end

      unless @mode
        puts file.blue
        if File.read(file).match(/#\+qiita_(.+)/)
          system ("qiita post #{file} open") if File.read(file).match(/#\+(.+)_public/)
          system ("qiita post #{file} teams") if File.read(file).match(/#\+(.+)_teams/)
          system ("qiita post #{file} private") if File.read(file).match(/#\+(.+)_private/)
        else
          system ("qiita post #{file}")
        end
      else
        puts "qiita post #{file} #{@mode}".blue
        system "qiita post #{file} #{@mode}"
      end
    end
  end

  def check_options(string)
    ["teams", "private", "public"].each do |i|
      if string.include?(i)
        @mode = i
        break
      else
        @mode = false
      end
    end

    @exclude_files = []
    if string.include?("--exclude")
      @exclude_files = string.grep(/.org/)
    end
  end
end
