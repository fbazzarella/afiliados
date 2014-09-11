class CampaignMailer < ActionMailer::Base
  default from: 'Felipe Bazzarella <felipe@bazzarella.com>'

  def shot(shot)
    @shot = shot
    add_custom_headers(@shot)
    mail(to: @shot.email.address, subject: @shot.campaign.subject)
  end

  private

  def add_custom_headers(shot)
    json = "{\"shot_id\": #{shot.id}}"

    headers['X-SMTPAPI']             = "{\"unique_args\": #{json}}"
    headers['X-Mailgun-Campaign-Id'] = "campaign_#{shot.campaign.id}"
    headers['X-Mailgun-Variables']   = json
  end
end
