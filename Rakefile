ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test, :development)

require "bundler/gem_tasks"

require "rake/dsl_definition"
require "rake"
require "rspec/core/rake_task"

namespace :cf do
  desc "Attempt to create new cf-release final release"
  task :release do
    require "yaml"
    unless ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_KEY']
      $stderr.puts "Please provide $AWS_ACCESS_KEY and $AWS_SECRET_KEY to run task"
      exit 1
    end

    # get properties for task
    # TODO $BLOBSTORE_NAME & $RELEASE_NAME should be fixed for the $PROJECT_DIR
    aws_access_key = ENV['AWS_ACCESS_KEY']
    aws_secret_key = ENV['AWS_SECRET_KEY']
    blobstore_name = ENV['BLOBSTORE_NAME'] || 'daily-cloudfoundry-releases'
    release_name   = ENV['RELEASE_NAME'] || "appcloud-daily"
    project_dir = File.expand_path(ENV["PROJECT_DIR"] || ".")
    cf_release_dir = File.expand_path(ENV["CF_RELEASE_DIR"] || "/tmp/cf-release")

    git_repo = ENV["CF_RELEASE_GIT"] || "https://github.com/cloudfoundry/cf-release.git"
    git_branch = ENV["CF_RELEASE_BRANCH"] || "release-candidate"
    if File.directory?(cf_release_dir)
      chdir(cf_release_dir) do
        sh "git pull"
      end
    else
      if `git clone -h 2>&1 | grep "single-branch"`.strip.size == 0
        sh "git clone -b #{git_branch} #{git_repo} #{cf_release_dir}"
      else
        sh "git clone --single-branch -b #{git_branch} #{git_repo} #{cf_release_dir}"
      end
    end

    release_dirs = %w[.final_builds releases config]

    chdir(cf_release_dir) do
      sh "git checkout ."

      File.open("Gemfile", "w") do |file|
        file << <<-RUBY
source 'https://rubygems.org'
source 'https://s3.amazonaws.com/bosh-jenkins-gems/'
gem "bosh_cli", "~> 1.5.0.pre"
        RUBY
      end

      Bundler.with_clean_env do
        ENV['NOEXEC']="skip"

        sh "bundle install"
        sh "./update"
        sh "bundle exec bosh sync blobs"
        sh "bundle exec bosh -n create release --force"
      end
    end

    chdir(cf_release_dir) do
      # copy in our release folders (config)
      mkdir_p("config")
      File.open("config/dev.yml", "w") do |file|
        file << {
          "dev_name" => release_name
        }.to_yaml
      end
      File.open("config/final.yml", "w") do |file|
        file << {
          "final_name" => release_name,
          "blobstore" => {
            "provider" => "s3",
            "options" => {
              "bucket_name" => blobstore_name,
              "access_key_id" => aws_access_key,
              "secret_access_key" => aws_secret_key,
              "encryption_key" => "PERSONAL_RANDOM_KEY",
            }
          }
        }.to_yaml
      end
      File.open("config/private.yml", "w") do |file|
        file << { "blobstore" => {
            "s3" => {
              "access_key_id" => aws_access_key,
              "secret_access_key" => aws_secret_key
            }
          }
        }.to_yaml
      end

      # create new final release
      Bundler.with_clean_env do
        ENV['NOEXEC']="skip"

        sh "bundle exec bosh -n create release --final --force"
      end
    end


    mkdir_p(project_dir)

    # copy release folders back into +project_dir+
    release_dirs.each do |dir|
      cp_r(File.join(cf_release_dir, dir), project_dir)
    end

    # cleanup for next time
    chdir(cf_release_dir) do
      sh "rm config/private.yml"
      sh "git checkout ."
    end
  end
end

task :cleanup do
  FileUtils.rm_rf("tmp")
end

if defined?(RSpec)
  namespace :spec do
    desc "Run Unit Tests"
    unit_rspec_task = RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/unit/**/*_spec.rb"
      t.rspec_opts = %w(--format documentation --color)
    end

    desc "Run Integration Tests"
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = "spec/integration/**/*_spec.rb"
      t.rspec_opts = %w(--format documentation --color)
    end
  end

  desc "Run tests"
  task :spec => %w(cleanup spec:unit spec:integration)

  task :default => [:spec]
end

