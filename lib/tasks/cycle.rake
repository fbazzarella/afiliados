namespace :foreman do
  task export: :environment do
    sh "echo '#{ENV['APP_PASSWORD']}' | rvmsudo -S foreman export upstart /etc/init -a #{ENV['APP_NAME']}-#{ENV['RAILS_ENV']} -u #{ENV['APP_USER']}"
  end
end

namespace :monit do
  task start: :environment do
    do_ :start
  end

  task restart: :environment do
    do_ :restart
  end

  private

  def do_(action)
    sh "echo '#{ENV['APP_PASSWORD']}' | sudo -S monit #{action.to_s} #{ENV['APP_NAME']}-#{ENV['RAILS_ENV']}"
  end
end

namespace :puma do
  task restart: :environment do
    sh "kill -10 $(cat /tmp/#{ENV['APP_NAME']}-#{ENV['RAILS_ENV']}.pid)"
  end
end
