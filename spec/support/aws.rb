module AwsHelpers
  def pending_without_blobstore_credentials
    unless ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_KEY']
      pending "Please provide $AWS_ACCESS_KEY and $AWS_SECRET_KEY to run integration tests"
    end
  end

  def fog
    
  end
end
