require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
  describe '#shot' do
    let!(:shot) { create(:shot) }

    subject { CampaignMailer.shot(shot) }

    it { expect(subject.header['From'].to_s).to be_eql('Felipe Bazzarella <fbazzarella@gmail.com>') }
    it { expect(subject.header['To'].to_s).to be_eql(shot.email.address) }
    it { expect(subject.subject).to be_eql('Oopa! Dá uma olhada :D') }
    it { expect(subject.body.to_s).to_not be_empty }
    it { expect{subject.deliver}.to change(ActionMailer::Base.deliveries, :size).by(1) }
  end
end
