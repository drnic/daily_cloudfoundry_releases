describe "rake cf:release" do
  it "can be found" do
    `rake -T cf:release | grep cf:release`.strip.size.should > 0
  end
  before do
    # fail fast if no s3 credentials
    # delete s3 blobstore bucket for tests
    # recreate home
  end
end