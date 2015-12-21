class CampaignMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM']

  def self.delivered_email(mail)
    shot_id = mail.header['X-Shot-Id'].to_s.to_i
    Shot.find(shot_id).touch(:relayed_at)
  end

  def shot(shot)
    @shot       = shot
    @email      = @shot.list_item.email
    @newsletter = @shot.campaign.newsletter

    mail_params = {
      to:      @email.address,
      from:    @newsletter.from,
      subject: @newsletter.subject
    }

    add_custom_headers(@shot)

    mail(mail_params) { |format| format.html { @newsletter.body } }
  end

  private

  def add_custom_headers(shot)
    headers['X-Shot-Id'] = shot.id
    # headers['X-SMTPAPI'] = "{\"unique_args\": {\"shot_id\": #{shot.id}}}"
    # headers['X-Mailgun-Campaign-Id'] = "campaign_#{shot.campaign.id}"
    # headers['X-Mailgun-Variables']   = "{\"shot_id\": #{shot.id}}"
  end
end
