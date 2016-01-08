class Storage

  def initialize(prefix=nil)
    s3 = Aws::S3::Resource.new
    @bucket = s3.bucket(ENV['BUCKET_NAME'])
    @prefix = prefix || Rails.env
  end

  def open_file(key)
    ext = File.extname(key)

    tmpfile = Tempfile.new ['file', ext], encoding: 'ascii-8bit'
    tmpfile.write read_file(key)
    tmpfile.close

    File.open(tmpfile.path)
  end

  def read_file(key)
    object(key).get.body.read
  end

  def write_file(key, body)
    obj = object(key)
    obj.put body: body
  end

  def destroy_file(key)
    object(key).delete
  end

  private

    def object(key)
      @bucket.object(key_with_prefix(key))
    end

    def key_with_prefix(key)
      [@prefix, key].join '/'
    end

end
