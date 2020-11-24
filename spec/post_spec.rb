RSpec.describe QiitaPost do
  before :each do
    @post = QiitaPost.new("test", "hoge", "os")
  end

  it "check title and tags" do
    [['test1.org', "test", [{:name=>"test1"}, {:name=>"test2"}]],
     ['test2.org', "ruby", [{:name=>"ruby"}, {:name=>"qiita"}]],
     ['test3.org', "practice ruby",[{:name=>"ruby"}]]
    ].each do |src, title, tags|
      conts = File.read("spec/tests/#{src}")
      p [src, title, tags]
      expect(@post.get_title_tags(conts)).to eq [title, tags]
    end
  end

  it "check patch or post" do
    [['test1.org',"private","",false],
     ['test1.org',"public","",false],
     ['test2.org',"teams","teamshoge",true],
     ['test2.org',"private","privatehoge",true],
     ['test2.org',"public","",false],
     ['test3.org',"public","publichoge",true],
     ['test3.org',"private","privatehoge",true],
     ['test3.org',"teams","",false]
    ].each do |src, option, qiita_id, patch|
      conts = File.read("spec/tests/#{src}")
      p [src, qiita_id, patch]
      expect(@post.select_patch_or_post(conts, option)).to eq [qiita_id, patch]
    end
  end

  it "select right option" do
    [['qiita',["https://qiita.com/", false]],
     ["private", ["https://qiita.com/", true]],
     [nil, ["https://qiita.com/", true]],
     ["teams", [nil, false]],
     ["open",["https://qiita.com/", false]],
     ["public",["https://qiita.com/", false]],
     ].each do |val,res|
      p [val,res]
      expect(@post.select_option(val)).to eq res
    end
  end

  it "check twitter option" do
    [['test1.org', 'public', true],
     ['test1.org', 'private', false],
     ['test2.org', 'public', false],
     ['test2.org', 'private', false],
     ['test3.org', 'public', false],
     ['test3.org', 'private', false],
     ['test4.org', 'public', true],
     ['test4.org', 'private', false]
    ].each do |src, option, res|
      p [src, option, res]
      conts = File.read("spec/tests/#{src}")
      expect(@post.select_twitter(conts, option)).to eq res
    end
  end
end
