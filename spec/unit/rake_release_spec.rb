describe "rake release" do
  it "can be found" do
    `rake -T cf:release | grep cf:release`.strip.size.should > 0
  end
end