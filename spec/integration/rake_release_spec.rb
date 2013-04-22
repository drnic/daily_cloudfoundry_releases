describe "rake cf:release" do
  include AwsHelpers
  include FileUtils

  let(:blobstore_name) { 'daily-cloudfoundry-releases-test' }

  before do
    pending_without_blobstore_credentials
    delete_blobstore(blobstore_name)
  end

  it "requires credentials" do
    sh "bundle exec rake cf:release"
    File.should be_directory("tmp/cf-release")
  end
end