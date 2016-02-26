namespace :postgres do
  task dump: :environment do
    config    = ActiveRecord::Base.configurations[Rails.env]
    file_name = "#{config['database']}_#{Time.now.strftime('%Y%m%d%H%M%S')}.pgsql"
    file_path = "#{Rails.root}/#{file_name}"

    system "PGPASSWORD=#{config['password']} pg_dump --clean -h #{config['host'] || 'localhost'} -U #{config['username']} #{config['database']} > #{file_path}"
    system "bzip2 -9 #{file_path}"
    system "scp -i #{Rails.root}/.id_rsa #{file_path}.bz2 #{ENV['REMOTE_PATH']}:#{file_name}.bz2"
    system "rm #{file_path} #{file_path}.bz2"
  end
end
