RSpec.describe QiitaBase do
  #before :each do
   # @spath = SelectPath.new()
  #end

  it "check qiita get path" do
    [["teams","https://nishitani.qiita.com","api/v2/items?page=1&per_page=100"],
     ["qiita","https://qiita.com/","api/v2/authenticated_user/items?page=1&per_page=100"]
    ].each do |mode, qiita, path|
      p [mode,qiita,path]
      expect(QiitaBase.new().select_access_path(mode, qiita)).to eq [qiita, path]
    end
  end
end
