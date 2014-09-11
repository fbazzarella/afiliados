require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
  describe '#shot' do
    let!(:shot) { create(:shot) }

    subject { CampaignMailer.shot(shot) }

    it { expect(subject.header['From'].to_s).to be_eql('Felipe Bazzarella <felipe@bazzarella.com>') }
    it { expect(subject.header['To'].to_s).to be_eql(shot.email.address) }

    it { expect(subject.header['X-SMTPAPI'].to_s).to be_eql("{\"unique_args\": {\"shot_id\": #{shot.id}}}") }
    it { expect(subject.header['X-Mailgun-Campaign-Id'].to_s).to be_eql("campaign_#{shot.campaign.id}") }
    it { expect(subject.header['X-Mailgun-Variables'].to_s).to be_eql("{\"shot_id\": #{shot.id}}") }

    it { expect(subject.subject).to be_eql(shot.campaign.subject) }
    it { expect{subject.deliver}.to change(ActionMailer::Base.deliveries, :size).by(1) }
  end
end
