class CampaignMailer < ActionMailer::Base
  RELAYS_PATH = "#{Rails.root}/.relays"

  default from: ENV['SMTP_FROM']

  def self.delivered_email(mail)
    Shot.find(mail.header['X-Shot-Id'].to_s.to_i).tap do |shot|
      shot.touch(:relayed_at)
      shot.campaign.increment!(:delivered)
    end
  end

  def shot(shot_id)
    shot = Shot.find(shot_id)

    randomize_relay!
    add_custom_headers_for shot

    newsletter = shot.campaign.newsletter

    mail_params = {
      to:      shot.list_item.email.address,
      from:    newsletter.from,
      subject: newsletter.subject
    }

    mail(mail_params) { |format| format.html { newsletter.body_for shot } }
  end

  private

  def add_custom_headers_for(shot)
    headers['X-Shot-Id'] = shot.id
    headers['X-SMTPAPI'] = "{\"unique_args\": {\"shot_id\": #{shot.id}}}"
    headers['X-Mailgun-Campaign-Id'] = "campaign_#{shot.campaign.id}"
    headers['X-Mailgun-Variables']   = "{\"shot_id\": #{shot.id}}"
  end

  def randomize_relay!
    relays = File.open(RELAYS_PATH, "rb").read.split("\n").map(&:strip)
    ActionMailer::Base.smtp_settings.merge!(address: relays.sample)
  end
end
