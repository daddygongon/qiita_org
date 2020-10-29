require "colorize"

class AccessQiita
  def initialize(access_token, qiita, path)
    @access_token = access_token
    @qiita = qiita
    @path = path
  end

  def access_qiita()
    uri = URI.parse(@qiita + @path)

    headers = { "Authorization" => "Bearer #{@access_token}",
                "Content-Type" => "application/json" }

    begin
      response = URI.open(
                          "#{uri}",
                          "Authorization" => "#{headers["Authorization"]}",
                          )
    rescue => e
      puts "#{$!}".red
      exit
    else
      items = JSON.parse(response.read)
      return items
    end
  end
end
