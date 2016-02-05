class ListImportJob < ActiveJob::Base
  queue_as :lists

  def perform(list_id)
    ListHandler.import(list_id)
  end
end
