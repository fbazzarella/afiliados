require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
  describe '.shot' do
    pending

    # let!(:shot) { create(:shot) }

    # subject { CampaignMailer.shot(shot) }

    # it { expect(subject.header['From'].to_s).to be_eql(ENV['SMTP_FROM']) }
    # it { expect(subject.header['To'].to_s).to be_eql(shot.list_item.email.address) }

    # it { expect(subject.header['X-Shot-Id'].to_s.to_i).to be_eql(shot.id) }
    # it { expect(subject.header['X-SMTPAPI'].to_s).to be_eql("{\"unique_args\": {\"shot_id\": #{shot.id}}}") }
    # it { expect(subject.header['X-Mailgun-Campaign-Id'].to_s).to be_eql("campaign_#{shot.campaign.id}") }
    # it { expect(subject.header['X-Mailgun-Variables'].to_s).to be_eql("{\"shot_id\": #{shot.id}}") }

    # it { expect(subject.subject).to be_eql(shot.campaign.name) }

    # it { expect{ subject.deliver_now; shot.reload }.to change(shot, :relayed_at) }
    # it { expect{ subject.deliver_now }.to change(ActionMailer::Base.deliveries, :size).by(1) }
  end
end
