namespace :emails do
  def import!
    require 'csv'
    require 'colored'

    puts "Importing emails to the database...".bold

    count = {saved: 0, invalid: 0, partial: 0}

    (1..4).each do |i|
      file_name = "emails_#{i}.csv"

      CSV.foreach(Rails.root.join('tmp', 'imports', file_name)) do |row|
        count[:partial] += 1

        email = Email.new(address: row[0].try(:strip))

        if email.valid?
          email.save

          print '.'.green
          count[:saved] += 1
        else
          ImportError.create({
            file_name:      file_name,
            line_number:    count[:partial],
            line_string:    row[0],
            error_messages: email.errors.messages.inspect
          })

          print '.'.red
          count[:invalid] += 1
        end
      end

      count[:partial] = 0
    end

    puts "\nDone! #{count[:saved]} saved and #{count[:invalid]} ignored.".bold
  end

  desc 'Import emails from a CSV file to the database'
  task import: :environment do
    import!
  end

  desc 'Delete all emails from the database'
  task clean: :environment do
    print "Deleting emails from the database...".bold

    ActiveRecord::Base.connection.execute('delete from emails')
    ActiveRecord::Base.connection.execute('delete from import_errors')

    puts " Done!".bold
  end
end
