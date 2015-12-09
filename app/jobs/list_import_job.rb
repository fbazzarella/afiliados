class ListImportJob < ActiveJob::Base
  queue_as :default

  def perform(list)
    ListHandler.import_to_database(list)
  end
end
