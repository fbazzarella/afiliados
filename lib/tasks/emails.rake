namespace :emails do
  def import!
    require 'csv'
    require 'colored'

    puts "Importing emails to the database...\n".bold

    count = {saved: 0, invalid: 0, lines: 0}

    (1..8473).each do |i|
      file_name = "emails_#{i.to_s.rjust(5, '0')}"
      print "Importing #{file_name}... "

      begin
        CSV.foreach(Rails.root.join('tmp', 'imports', file_name)) do |row|
          count[:lines] += 1

          email = Email.new(address: row[0].try(:strip))

          if email.valid?
            email.save

            count[:saved] += 1
          else
            ImportError.create({
              file_name: file_name,
              line_number: count[:lines],
              line_string: row[0],
              error_messages: email.errors.messages.inspect
            })

            count[:invalid] += 1
          end
        end

        puts "Done!"
      rescue Exception => msg
        puts "Exception: #{msg}"
      end

      count[:lines] = 0
    end

    puts "\nDone! #{count[:saved]} saved and #{count[:invalid]} ignored.".bold
  end

  desc 'Import emails from a CSV file to the database'
  task import: :environment do
    # Use the command bellow to call this task:
    # nohup bundle exec rake emails:import 2>&1 >> log/emails_import.log &

    import!
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
