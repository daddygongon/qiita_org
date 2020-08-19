require "colorize"
require "fileutils"

class QiitaConfig
  def initialize(option, input)
    setup = "#{ENV["HOME"]}/.qiita.conf"
    # check qiita.conf or copy qiita.conf
    if File.exists?("#{ENV["HOME"]}/.qiita.conf")
      puts setup.green
      conts = File.read(setup)
      puts conts.gsub(/{|}|,/, "{" => "", "}" => "", "," => "")
    else
      FileUtils.cp("lib/qiita_org/.qiita.conf", setup, verbose: true)
    end

    if option == "access_token"
      conts = File.readlines(setup)
      p conts[1]
    end
  end
end
