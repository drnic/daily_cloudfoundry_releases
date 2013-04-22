describe "rake cf:release" do
  include AwsHelpers
  include ProjectHelpers
  include FileUtils

  let(:blobstore_name) { 'daily-cloudfoundry-releases-test' }
  let(:cf_release_dir) { File.expand_path("../../../tmp/cf-release", __FILE__) }
  let(:project_dir) { File.expand_path("../../../tmp/project", __FILE__) }

  before do
    pending_without_blobstore_credentials
    delete_blobstore(blobstore_name)
    delete_test_project_dir
    override_project_settings
    sh "bundle exec rake cf:release"
  end

  it "created release folders in this project" do
    File.should be_exist("#{project_dir}/config/final.yml")
    File.should be_exist("#{project_dir}/config/private.yml")
    File.should be_directory("#{project_dir}/.final_builds")
    File.should be_directory("#{project_dir}/releases")
    File.should be_exist("#{project_dir}/releases/appcloud-daily-1.yml")
  end

end