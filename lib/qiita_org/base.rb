require "colorize"
require "qiita_org/error_message.rb"

class QiitaBase
  def initialize()
  end

  def check_pc_os()
    if system "sw_vers"
      return os = "mac"
    elsif system "wmic.exe os get caption"
      return os = "windows"
    else
      return nil
    end
  end

  def pick_up_option(src)
    lines = File.readlines(src)

    lines.each do |line|
      m = []
      if m = line.match(/\#\+qiita_(.+): (.+)/)
        option = m[1]
        unless option == "public" || option == "teams" || option == "private"
          next
        end
        return option
      end
    end
    return option = "private"
  end

  def search_conf_path(dir, home)
    while dir != home
      if File.exists?(File.join(dir, ".qiita.conf"))
        return dir
      else
        dir = dir.match(/(.+)\//)[1]
      end
    end
    return dir
  end

  def select_access_path(mode, teams_url)
    case mode
    when "teams"
      qiita = teams_url
      path = "api/v2/items?page=1&per_page=100"
    else
      qiita = "https://qiita.com/"
      path = "api/v2/authenticated_user/items?page=1&per_page=100"
    end
    return qiita, path
  end

  def set_config()
    conf_dir = search_conf_path(Dir.pwd, Dir.home)
    lib = File.expand_path("../../../lib", __FILE__)
    if conf_dir != Dir.home
      puts "config file path: #{conf_dir.gsub(Dir.home, "~")}".green
    else
      puts "config file path: #{conf_dir}".green
    end

    conf_path = File.join(conf_dir, ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    access_token = conf["access_token"]
    teams_url = conf["teams_url"]
    display = conf["display"]
    ox_qmd_load_path = File.join(lib, "qiita_org", "ox-qmd", "ox-qmd")

    ErrorMessage.new().access_token_error(access_token)

    return access_token, teams_url, display, ox_qmd_load_path
  end

  def file_open(os, order)
    case os
    when "mac"; system "open #{order}"
    when "windows"; system "explorer.exe #{order}"
    else; system "xdg-open #{order}"     end
  end

  def get_report_id(src, option)
    conts = File.read(src)
    if conts.match?(/^\#\+qiita_#{option}:\s(.+)/)
      id = conts.match(/\#\+qiita_#{option}: (.+)/)[1]
    else
      id = nil
    end
    return id
  end
end
