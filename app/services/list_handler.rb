class ListHandler
  LISTS_PATH = File.join(Rails.root, '/tmp/lists/')

  class << self
    def save_to_disk(file, uuid)
      persist_lists_path!

      file_path = File.join(LISTS_PATH, uuid)

      File.open(file_path, 'wb') do |f|
        f.write(filter_list(file))
        file_path
      end
    end

    def import_to_database(list_import)
      ar    = ActiveRecord::Base.connection
      file  = File.open(list_import.file_path)

      redis   = Redis.new
      publish = {imported_lines: -1}

      file.each_line do |line|
        publish[:imported_lines] += 1

        if publish[:imported_lines].zero?
          publish.merge!(total_lines: line.to_i)
          next
        end

        now = Time.zone.now

        sql = %Q(
          INSERT INTO emails
            (address, created_at, updated_at)
          VALUES
            ('#{line.strip}', '#{now}', '#{now}')
        )

        begin
          ar.execute sql
        rescue Exception => msg
          Rails.logger.warn "Exception: #{msg}"
        end

        if (publish[:imported_lines] % 1000).zero? || publish[:imported_lines] == publish[:total_lines]
          publish.merge!(total_email_count: Email.count)

          redis.publish 'list:import-progress', publish.to_json
        end
      end

      list_import.destroy
    end

    private

    def persist_lists_path!
      FileUtils.mkdir_p(LISTS_PATH) if not File.exist?(LISTS_PATH)
    end

    def filter_list(file)
      if file.present?
        filter_pattern = /([a-zA-Z0-9._%+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/

        file.read.scan(filter_pattern).flatten.tap do |file|
          file.unshift("#{file.size}")
        end.join("\n")
      end
    end
  end
end
