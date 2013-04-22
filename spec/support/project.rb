module ProjectHelpers
  # so tests do not modify this project; but a fake project
  def override_project_settings
    ENV['BLOBSTORE_NAME'] = blobstore_name
    ENV['PROJECT_DIR'] = project_dir
    ENV['CF_RELEASE_DIR'] = cf_release_dir
  end

  def delete_test_project_dir
    FileUtils.rm_rf(project_dir)
  end
end