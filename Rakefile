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
    repo_dir = "tmp/cf-release"
    git_repo = ENV["CF_RELEASE_GIT"] || "https://github.com/cloudfoundry/cf-release.git"
    git_branch = ENV["CF_RELEASE_BRANCH"] || "release-candidate"
    if File.directory?(repo_dir)
      FileUtils.chdir(repo_dir) do
        sh "git pull"
      end
    else
      sh "git clone --single-branch -b #{git_branch} #{git_repo} #{repo_dir}"
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

