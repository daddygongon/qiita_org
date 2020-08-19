require "net/https"
require "json"
require "open-uri"
require "io/console"

class QiitaGet
  def initialize(mode)
    conf_path = File.join(ENV["HOME"], ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    access_token = conf["access_token"]
    teams_url = conf["teams_url"]

    case mode
    when "teams"
      qiita = teams_url
      path = "api/v2/items?page=1&per_page=100"
    else
      qiita = "https://qiita.com/"
      path = "api/v2/authenticated_user/items?page=1&per_page=100"
    end

    uri = URI.parse(qiita + path)

    headers = { "Authorization" => "Bearer #{access_token}",
      "Content-Type" => "application/json" }

    response = URI.open(
                        "#{uri}",
                        "Authorization" => "#{headers["Authorization"]}",
                        )
    items = JSON.parse(response.read)

    items.each do |item|
      p "title: #{item["title"]}"
      p "Do you gets it?(y/n)"
      p ans = STDIN.getch

      next if ans == "n"
      if ans == "y"
        p $title = item["title"] #.gsub(/ |\(|\)/, " " => "_", "(" => "", ")" => "")
        $id = item["id"]
        $tags = []
        $private = item["private"]
        item["tags"].each do |tag|
          $tags << tag["name"]
        end
        p filename = "#{$id}.md"
        File.write(filename, item["body"])
        break
      end
    end

    system "pandoc #{$id}.md -o #{$id}.org"
    conts = File.read("#{$id}.org")

    head = <<"EOS"
#+OPTIONS: ^:{}
#+STARTUP: indent nolineimages
#+TITLE: #{$title}
#+AUTHOR: Your Name
#+EMAIL:
#+LANGUAGE:  jp
# +OPTIONS:   H:4 toc:t num:2
#+OPTIONS:   toc:nil
#+TAG: #{$tags}
#+SETUPFILE: ~/.emacs.d/org-mode/theme-readtheorg.setup\n
EOS

    if $private
      mode = "private"
    end

    File.write("#{$id}.org", "#+#{mode}_id: #{$id}\n" + head + conts)

    puts "created #{$id}.org"
    system "rm -f #{$id}.md"
  end
end
