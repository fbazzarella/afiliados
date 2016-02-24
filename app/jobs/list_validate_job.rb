class ListValidateJob < ActiveJob::Base
  queue_as :lists

  def perform(list_id)
    ListHandler.validate(list_id)
  end
end
