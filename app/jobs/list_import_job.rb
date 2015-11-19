class ListImportJob < ActiveJob::Base
  queue_as :default

  def perform(list_import)
    ListHandler.import_to_database(list_import)
  end
end
