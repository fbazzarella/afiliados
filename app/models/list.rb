require 'csv'

class List < ActiveRecord::Base
  mount_uploader :file, ListUploader

  has_many :list_items, dependent: :nullify
  has_many :emails, through: :list_items

  validates :name, presence: true

  before_validation on: :create do
    self.name = file.file.original_filename if file.present?
  end

  after_create do
    ListImportJob.perform_later(self.id)
  end

  def to_json
    {id: id}
  end
end
