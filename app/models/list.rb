class List < ActiveRecord::Base
  mount_uploader :file, ListUploader

  validates :name, presence: true

  with_options on: :create do
    before_validation do
      self.name = file.file.original_filename if file.present?
    end

    after_save do
      ListImportJob.perform_later(self)
    end
  end

  def to_json
    {id: id}
  end
end
