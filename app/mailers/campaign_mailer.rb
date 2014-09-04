class CampaignMailer < ActionMailer::Base
  include SendGrid
  
  default from: 'Felipe Bazzarella <cursos@bazzarella.com>'

  def shot(shot)
    @shot = shot

    sendgrid_unique_args({shot_id: @shot.id})

    mail(to: @shot.email.address, subject: @shot.campaign.name)
  end
end
