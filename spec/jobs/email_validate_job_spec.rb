require 'rails_helper'

RSpec.describe EmailValidateJob, type: :job do
  describe '.perform_later' do
    it { expect{ described_class.perform_later(1, 'string') }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1) }
  end
end
