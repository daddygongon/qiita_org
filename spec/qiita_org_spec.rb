RSpec.describe QiitaOrg do
  it "has a version number" do
    expect(QiitaOrg::VERSION).not_to be nil
  end
end

RSpec.describe QiitaPost do
  it "does something useful" do
    ['qiita','open','teams','private','public'].each do |ele|
      p ele
      p QiitaPost::select_option(ele)
    end
  end
end
