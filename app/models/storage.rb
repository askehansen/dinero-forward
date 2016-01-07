class Storage

  def initialize
    s3 = Aws::S3::Resource.new
    @bucket = s3.bucket(ENV['BUCKET_NAME'])
  end

  def open_file(key)
    filename = key.split('/').last
    ext = File.extname(key)

    tmpfile = Tempfile.new [filename, ext], encoding: 'ascii-8bit'
    tmpfile.write read_file(key)
    tmpfile.close

    file = File.open tmpfile.path
  end

  def read_file(key)
    @bucket.object(key_with_prefix(key)).get.body.read
  end

  def write_file(key, body)
    obj = @bucket.object(key_with_prefix(key))
    obj.put body: body
  end

  def destroy_file(key)
    @bucket.object(key_with_prefix(key)).delete
  end

  private

    def key_with_prefix(key)
      [Rails.env, key].join '/'
    end

end
