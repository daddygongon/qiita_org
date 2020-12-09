require "qiita_org/search_conf_path.rb"
require "qiita_org/error_message.rb"

class SetConfig
  def initialize()
    search = SearchConfPath.new(Dir.pwd, Dir.home)
    @lib = File.expand_path("../../../lib", __FILE__)
    @conf_dir = search.search_conf_path()
    if @conf_dir != Dir.home
      puts "config file path: #{@conf_dir.gsub(Dir.home, "~")}".green
    else
      puts "config file path: #{@conf_dir}"
    end
  end

  def set_config()
    conf_path = File.join(@conf_dir, ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    access_token = conf["access_token"]
    teams_url = conf["teams_url"]
    display = conf["display"]
    ox_qmd_load_path = File.join(@lib, "qiita_org", "ox-qmd", "ox-qmd")

    ErrorMessage.new().access_token_error(access_token) #== false
#      puts "Please setting ACCESS_TOKEN".red
#      exit

    return access_token, teams_url, display, ox_qmd_load_path
  end
end
