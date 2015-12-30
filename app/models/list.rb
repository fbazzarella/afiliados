require 'csv'

class List < ActiveRecord::Base
  mount_uploader :file, ListUploader

  has_many :list_items, dependent: :nullify
  has_many :emails, through: :list_items

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

  def to_csv
    CSV.generate do |csv|
      list_items.valid.each do |list_item|
        csv << [list_item.email.address]
      end
    end
  end
end
