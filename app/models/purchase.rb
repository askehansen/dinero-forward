class Purchase < ApplicationRecord
  belongs_to :message
  has_one :user, through: :message
  # belongs_to :user, through: :message

  enum status: {
    unprocessed: 0,
    processed: 1,
    processing: 9,
    failed: 10
  }

  has_one_attached :file_v2

  def validate_file!
    case file_v2.blob.content_type
    when "application/pdf"
      body = file_v2.download
      raise InvalidFileError, 'file does not contain %%EOF marker' unless body.include?('%%EOF')
    end
  end

  def file
    tmpfile = Tempfile.new(["file", file_v2.filename.extension_with_delimiter], encoding: 'ascii-8bit')
    tmpfile.write(file_v2.download)
    tmpfile.rewind
    tmpfile
  end

  def self.processed_count
    self.count + 71_441
  end

  class InvalidFileError < StandardError
  end

end
