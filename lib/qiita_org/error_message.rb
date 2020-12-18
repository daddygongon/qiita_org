require "colorize"
require "json"

class ErrorMessage
  def initialize()
  end

  def access_token_error(access_token)
    if access_token == ""
      puts "Please setting ACCESS_TOKEN".red
      puts "Hint: qiita config global access_token 'your access_token'".red
      puts "Hint: qiita config local access_token 'your access_token'".red
      exit
    end
  end

  def teams_url_error(teams_url)
    if teams_url == ""
      puts "Please setting teams_url".red
      puts "Hint: qiita config global teams_url 'https://foge.qiita.com/'".red
      puts "Hint: qiita config local teams_url 'https://foge.qiita.com/'".red
      exit
    end
  end

  def qiita_access_error(e)
    puts "#{$!}".red
    exit
  end

  def qiita_post_error(response, file)
    message = response.message
    if message != "Created"
      if message != "OK"
        if message == "Unauthorized"
          puts "#{message}".red
          puts "Please check your access_token.".red
          system "rm #{file}"
          exit
        elsif message == "Forbidden"
          puts "#{message}".red
          puts "You are not authorized to access this page. please check qiita_id.".red
          system "rm #{file}"
          exit
        elsif message == "Not Found"
          puts "#{message}".red
          system "rm #{file}"
          exit
        else
          puts "#{message}".red
          system "rm #{file}"
          exit
        end
      end
    end
  end

  def config_set_error(conf_dir)
    conf_path = File.join(conf_dir, ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    check = true

    if conf["name"] == ""
      puts "Please set your name in config".red
      puts "Hint: qiita config global name 'YOUR NAME'".red
      puts "Hint: qiita config local name 'YOUR NAME'".red
#      system "rm template.org"
      check = false
    end

    if conf["email"] == ""
      puts "Please set your email in config".red
      puts "Hint: qiita config global email 'youremail@example.com'".red
      puts "Hint: qiita config local name 'youremail@example.com'".red
      check = false
    end
    unless check
      exit
    end
  end

  def md_file_exists?(src, res)
    unless File.exists?(src.gsub(".org", ".md"))
      puts "Can not transform #{src.gsub(".org", ".md")} from #{src}, please chech org syntax.".red
      puts "Please confirm emacs version it 26 or more.".red
      exit
    else
      p res
    end
  end

  def many_tags_error(tags)
    if tags.count(",") >= 5
      puts "The maximum number of tag is five. Please delete some tags.".red
      exit
    end
  end
end
