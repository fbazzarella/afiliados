require 'csv'
require 'colored'

namespace :emails do
  def run_queue!(queue, threads = 1)
    workers = (0...threads).map do
      Thread.new do
        config = ActiveRecord::Base.configurations[Rails.env]
        ActiveRecord::Base.establish_connection(config)

        sleep 3

        begin
          while file_name = queue.pop(true)
            import_file(file_name)
          end
        rescue Exception
        end
      end
    end
    
    workers.map(&:join)
  end

  def import_file(file_name)
    sleep 1
    line = 0

    begin
      CSV.foreach(Rails.root.join('tmp', 'imports', file_name)) do |row|
        line += 1

        email = Email.new(address: row[0].try(:strip))

        if email.valid?
          email.save
        else
          ImportError.create({
            file_name: file_name,
            line_number: line,
            line_string: row[0],
            error_messages: email.errors.messages.inspect
          })
        end
      end
    rescue SystemCallError
    rescue Exception => msg
      puts "#{Time.zone.now.strftime("%FT%R")} Exception on #{file_name}: #{msg}"
    end
  end

  desc 'Import emails from a CSV file to the database'
  task :import, [:range, :threads] => :environment do |t, args|
    # Use the command bellow to call this task:
    # nohup bundle exec rake emails:import 2>&1 >> log/emails_import.log &

    range, threads = *args

    puts "#{Time.zone.now.strftime("%FT%R")} Importing emails to the database...\n".bold
  
    ActiveRecord::Base.connection_pool.disconnect!

    queue = Queue.new

    eval(range).each { |i| queue.push("emails_#{i.to_s.rjust(5, '0')}") }

    run_queue! queue, eval(threads)

    puts "\n#{Time.zone.now.strftime("%FT%R")} Done!".bold
  end

  desc 'Delete all emails from the database'
  task clean: :environment do
    print "Deleting emails from the database...".bold

    %w(emails import_errors).each do |table|
      ActiveRecord::Base.connection.execute("truncate #{table}")
    end

    puts " Done!".bold
  end
end
