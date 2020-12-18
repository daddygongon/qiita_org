RSpec.describe QiitaBase do
  it "check decide option" do
    [['test1.org', 'private'],
     ['test2.org', 'teams'],
     ['test3.org', 'public'],
     ['test4.org', 'private']
    ].each do |src, option|
      p [src, option]
      expect(QiitaBase.new().pick_up_option("spec/tests/#{src}")).to eq option
    end
  end
end
