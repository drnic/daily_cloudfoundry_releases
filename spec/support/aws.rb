module AwsHelpers
  def pending_without_blobstore_credentials
    unless ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_KEY']
      pending "Please provide $AWS_ACCESS_KEY and $AWS_SECRET_KEY to run integration tests"
    end
  end

  def fog_credentials
    {
      aws_access_key_id: ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY']
    }
  end

  def aws_region
    'us-east-1'
  end

  def fog_storage
    @fog_storage ||= Fog::Storage::AWS.new(fog_credentials.merge(region: aws_region))
  end

  def delete_blobstore(name)
    if directory = fog_storage.directories.get(name)
      files = directory.files.map{ |file| file.key }
      fog.delete_multiple_objects(bucket, files) unless files.empty?
    else
      fog_storage.directories.create(key: name, public: true)
    end
  end
end
