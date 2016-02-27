require 'csv'

class List < ActiveRecord::Base
  mount_uploader :file, ListUploader

  has_many :list_items, dependent: :nullify
  has_many :emails, through: :list_items

  validates :name, presence: true

  after_find do
    lists_path = "#{Rails.root}/public/lists/"

    begin
      self.valids_count = File.open(lists_path + "validos_#{id}_#{name}", "r").readlines.size
    rescue Exception
    end

    begin
      self.invalids_count = File.open(lists_path + "invalidos_#{id}_#{name}", "r").readlines.size
    rescue Exception
    end

    begin
      self.unknowns_count = File.open(lists_path + "desconhecidos_#{id}_#{name}", "r").readlines.size
    rescue Exception
    end

    self.save!

    seems_validated = emails_count == valids_count + invalids_count + unknowns_count
    update_attribute(:status, 'Validação Concluída') if emails_count > 0 && seems_validated
  end

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
