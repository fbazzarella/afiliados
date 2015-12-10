class ListUploader < CarrierWave::Uploader::Base
  storage :file

  def full_filename(for_file)
    model.id.to_s
  end

  def store_dir
    "tmp/lists"
  end

  def cache_dir
    "tmp/cache/lists"
  end

  def extension_white_list
    %w(csv txt)
  end
end
