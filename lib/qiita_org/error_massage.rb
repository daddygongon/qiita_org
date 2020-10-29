require "colorize"

class ErrorMassage
  def initialize()
  end

  def access_token_error(access_token)
    if access_token == ""
      puts "Please setting ACCESS_TOKEN".red
      exit
#      return false
    end
 #   return true
  end

  def teams_url_error(teams_url)
    if teams_url == ""
      puts "Please setting teams_url".red
      exit
    end
  end
end
