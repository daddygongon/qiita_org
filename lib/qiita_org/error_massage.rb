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
end
