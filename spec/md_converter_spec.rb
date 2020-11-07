RSpec.describe MdConverter do
  before :each do
    @converter = MdConverter.new()
  end

  it "check md converter" do
    [["test1.md", ["![fig1.png](https://example.com)\n"]],
     ["test2.md", ["![fig2.png](https://hogehoge)\n"]],
     ["test3.md", ["![img](figs/fig2.png)\n"]]
    ].each do |src, line|
      p [src, line]
      lines = File.readlines("spec/tests/#{src}")
      expect(@converter.convert_for_image(lines)).to eq line
    end
  end
end
