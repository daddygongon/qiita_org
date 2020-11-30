require "colorize"
#require "../qiita_org/qiita_org.rb"
require "qiita_org/post.rb"
require "qiita_org/upload.rb"
require "qiita_org/decide_option.rb"

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
    puts "post files: #{@files}".green
    @files.each do |file|
      mode = @option || DecideOption.new(file).decide_option()
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
        QiitaFileUpLoad.new(file, mode, @os).upload()
      end
    end
  end
end
