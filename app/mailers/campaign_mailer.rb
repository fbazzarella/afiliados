class CampaignMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM']

  def self.delivered_email(mail)
    shot_id = mail.header['X-Shot-Id'].to_s.to_i
    Shot.find(shot_id).touch(:relayed_at)
  end

  def shot(shot)
    @shot = shot
    add_custom_headers(@shot)
    mail(to: @shot.email.address, subject: @shot.campaign.subject)
  end

  def send_campaign(email_params)
    body = email_params.delete('body')

    mail(email_params) do |format|
      format.html { render html: body.html_safe }
    end
  end

  private

  def add_custom_headers(shot)
    headers['X-Shot-Id'] = shot.id
    headers['X-SMTPAPI'] = "{\"unique_args\": {\"shot_id\": #{shot.id}}}"
    headers['X-Mailgun-Campaign-Id'] = "campaign_#{shot.campaign.id}"
    headers['X-Mailgun-Variables']   = "{\"shot_id\": #{shot.id}}"
  end
end
