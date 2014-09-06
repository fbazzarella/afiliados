class CampaignMailer < ActionMailer::Base
  default from: 'Felipe Bazzarella <fbazzarella@gmail.com>'

  def shot(shot)
    @shot = shot

    add_custom_header(@shot.id)

    mail(to: @shot.email.address, subject: 'Oopa! Dá uma olhada :D')
  end

  private

  def add_custom_header(shot_id)
    json  = "{'shot_id': #{shot_id}}"

    headers['X-SMTPAPI']           = "{unique_args: #{json}}"
    headers['X-Mailgun-Variables'] = json
  end
end
