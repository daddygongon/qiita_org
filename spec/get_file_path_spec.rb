RSpec.describe GetFilePath do
  it "check return file path" do
    [['test1.org',["figs/fig1.png","../figs/fig2.png","figs/fig2.png"]],
     ['test2.org',["../figs/fig1.png"]],
     ['test3.org',["../../picture/picture1.png","../figs/fig3.png"]]
    ].each do |src, paths|
      p [src, paths]
      expect(GetFilePath.new("spec/tests/#{src}").get_file_path()).to eq paths
    end
  end
end
