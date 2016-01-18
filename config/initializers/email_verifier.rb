EmailVerifier.config do |config|
  # To get info about realness of given email address,
  # email_verifier connects with a mail server that email's domain
  # points to and pretends to send an email.
  # Some smtp servers will not allow you to do this
  # if you will not present yourself as a real user.
  config.verifier_email = ENV['VERIFIER_EMAIL_FROM']

  # If you are using Rails in test environment, the check will always succeed,
  # so that your CI servers will not try to contact SMTP servers.
  # You can change that behavior in the configuration block:
  config.test_mode = %w(development test).include?(Rails.env)
end
