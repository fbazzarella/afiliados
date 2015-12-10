class List < ActiveRecord::Base
  mount_uploader :file, ListUploader

  after_save on: :create do
    ListImportJob.perform_later(self)
  end

  def to_json
    {id: id}
  end
end
