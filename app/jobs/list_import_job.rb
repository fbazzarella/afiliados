class ListImportJob < ActiveJob::Base
  queue_as :lists

  def perform(list)
    ListHandler.import(list)
  end
end
