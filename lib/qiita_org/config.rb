require "colorize"
require "fileutils"

class QiitaConfig
  def initialize()
    setup = "#{ENV["HOME"]}/.qiita.conf"
    if File.exists?("#{ENV["HOME"]}/.qiita.conf")
      puts setup.green
      conts = File.read(setup)
      puts conts.gsub(/{|}|,/, "{" => "", "}" => "", "," => "")
    else
      FileUtils.cp("lib/qiita_org/.qiita.conf", setup, verbose: true)
    end
  end
end
