require 'rails_helper'

RSpec.describe ListImportJob, type: :job do
  describe '.perform_later' do
    clean_lists!

    let!(:list) { create(:list) }

    it { expect{ described_class.perform_later(list) }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1) }
  end
end
