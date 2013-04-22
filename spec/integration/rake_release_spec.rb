describe "rake cf:release" do
  include AwsHelpers
  before do
    pending_without_blobstore_credentials
    # fail fast if no s3 credentials
    # delete s3 blobstore bucket for tests
    # recreate home
  end
  it "requires credentials" do
    puts "hi"
  end
end