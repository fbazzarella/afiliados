class CampaignMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM']

  def self.delivered_email(mail)
    shot_id = mail.header['X-Shot-Id'].to_s.to_i
    Shot.find(shot_id).touch(:relayed_at)
  end

  def shot(shot)
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
end
