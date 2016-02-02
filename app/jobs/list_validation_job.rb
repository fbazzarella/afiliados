class ListValidationJob < ActiveJob::Base
  queue_as :lists

  def perform(email_id)
    ListHandler.validate(email_id)
  end
end
