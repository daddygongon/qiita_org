class SelectPath
  def initialize()
  end

  def select_path(mode)
    case mode
    when "teams"
      qiita = @teams_url
      path = "api/v2/items?page=1&per_page=100"
    else
      qiita = "https://qiita.com/"
      path = "api/v2/authenticated_user/items?page=1&per_page=100"
    end
    return qiita, path
  end
end
