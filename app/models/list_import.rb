class ListImport < ActiveRecord::Base
  attr_accessor :file, :uuid

  before_validation on: :create do
    self.uuid    ||= SecureRandom.uuid
    self.file_path = ListHandler.save_to_disk(file, self.uuid)
  end

  after_save on: :create do
    ListImportJob.perform_later(self)
  end

  after_destroy do
    FileUtils.rm(self.file_path)
  end
end
