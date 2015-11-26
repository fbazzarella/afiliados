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

  task stop: :environment do
    do_ :stop
  end

  private

  def do_(action)
    common = "echo '#{ENV['APP_PASSWORD']}' | sudo -S monit #{action.to_s} #{ENV['APP_NAME']}-#{ENV['RAILS_ENV']}"

    sh "#{common}-web"
    sh "#{common}-worker"
  end
end
