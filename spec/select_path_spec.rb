RSpec.describe SelectPath do
  before :each do
    @spath = SelectPath.new()
  end

  it "check qiita get path" do
    [["teams",nil,"api/v2/items?page=1&per_page=100"],
     ["qiita","https://qiita.com/","api/v2/authenticated_user/items?page=1&per_page=100"]
    ].each do |mode, qiita, path|
      p [mode,qiita,path]
      expect(@spath.select_path(mode)).to eq [qiita, path]
    end
  end
end
