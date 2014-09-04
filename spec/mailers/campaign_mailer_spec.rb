require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
  describe '#shot' do
    let!(:shot) { create(:shot) }

    subject { CampaignMailer.shot(shot) }

    it { expect(subject.header['From'].to_s).to be_eql('Felipe Bazzarella <cursos@bazzarella.com>') }
    it { expect(subject.header['To'].to_s).to be_eql(shot.email.address) }
    it { expect(subject.subject).to be_eql(shot.campaign.name) }
    it { expect(subject.body.to_s).to_not be_empty }
    it { expect{subject.deliver}.to change(ActionMailer::Base.deliveries, :size).by(1) }
  end
end
