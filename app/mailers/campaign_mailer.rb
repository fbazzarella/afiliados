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

    mail(mail_params) { |format| format.html { customize_body(@shot, @newsletter.body) } }
  end

  private

  def customize_body(shot, body)
    append_footer(shot, change_links(shot, body))
  end

  def change_links(shot, body)
    default_url = Rails.application.config.action_mailer[:default_url_options][:host]

    doc = Nokogiri::HTML(body)

    doc.css('a').each do |link|
      link_id = Link.create(shot_id: shot.id, url: link[:href]).id
      link[:href] = "https://#{default_url}/links/#{link_id}"
    end

    doc.to_html
  end

  def append_footer(shot, body)
    path     = "#{Rails.root}/app/views/campaign_mailer/_footer.html"
    template = File.open(path, "rb").read.gsub!(':shot_id', shot.id.to_s)

    Nokogiri::HTML(body.gsub!('</body>', "#{template}</body>")).to_html
  end

  def add_custom_headers(shot)
    headers['X-Shot-Id'] = shot.id
    # headers['X-SMTPAPI'] = "{\"unique_args\": {\"shot_id\": #{shot.id}}}"
    # headers['X-Mailgun-Campaign-Id'] = "campaign_#{shot.campaign.id}"
    # headers['X-Mailgun-Variables']   = "{\"shot_id\": #{shot.id}}"
  end
end
