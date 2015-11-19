class ListImport < ActiveRecord::Base
  attr_accessor :file

  before_validation on: :create do
    self.file_path = ListHandler.save_to_disk(file)
  end

  after_save on: :create do
    ListImportJob.perform_later(self)
  end

  after_destroy do
    FileUtils.rm(self.file_path)
  end
end
