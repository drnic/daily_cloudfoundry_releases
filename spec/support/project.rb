module ProjectHelpers
  # so tests do not modify this project; but a fake project
  def override_project_location
    ENV['PROJECT_DIR'] = project_dir
  end
end