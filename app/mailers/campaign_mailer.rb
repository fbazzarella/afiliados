class CampaignMailer < ActionMailer::Base
  include SendGrid
  
  default from: 'Felipe Bazzarella <fbazzarella@gmail.com>'

  def shot(shot)
    @shot = shot

    sendgrid_unique_args({shot_id: @shot.id})

    mail(to: @shot.email.address, subject: 'Oopa! Dá uma olhada :D')
  end
end
