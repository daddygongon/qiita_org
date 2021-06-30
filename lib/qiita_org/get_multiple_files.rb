require "colorize"
require "qiita_org/post.rb"
require "qiita_org/upload.rb"

class GetMultipleFiles
  def initialize(files, os, type)
    @files = files
    @option = nil
    @os = os
    @type = type
    unless @files[-1].match(/(.+).org/)
      @option = @files[-1]
      @files = @files[0..-2]
    end
  end

  def run()
    puts "#{@type} files: #{@files}".green
    @files.each do |file|
      mode = @option || QiitaBase.new().pick_up_option(file)
      puts "qiita #{@type} #{file} #{mode}".green
      if @type == "post"
        qiita = QiitaPost.new(file, mode, @os)
        begin
          qiita.select_option(mode)
        rescue RuntimeError => e
          puts $!
        else
          qiita.run
        end
      elsif @type == "upload"
        begin
          QiitaFileUpLoad.new(file, mode, @os).upload()
        rescue Exception => ex
          puts ex.message.red
        end
      end
    end
  end
end
