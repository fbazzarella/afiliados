class EmailValidateJob < ActiveJob::Base
  queue_as :lists

  def perform(list_item_id, list_name)
    ListHandler.email_validate(list_item_id, list_name)
  end
end
