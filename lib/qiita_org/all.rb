require "colorize"

class QiitaAll
  def initialize(mode)
    @mode = mode
    @files = Dir.glob("*.org")
    p @files
  end

  def run()
    @files.each do |file|
      if file == "template.org"
        next
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
end
