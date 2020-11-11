RSpec.describe DecideOption do
  it "check decide option" do
    [['test1.org', 'private'],
     ['test2.org', 'teams'],
     ['test3.org', 'public'],
     ['test4.org', 'private']
    ].each do |src, option|
      p [src, option]
      expect(DecideOption.new("spec/tests/#{src}").decide_option()).to eq option
    end
  end
end
